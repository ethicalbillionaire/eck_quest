class_name Stats extends Resource
## Stat class for character entities
## 
## Faction, BuffableStats
enum BuffableStats {
	MAX_HEALTH,
	DEF,
	ATK,
	WIS
}

enum Faction {
	PLAYER,
	ENEMY
}

const STAT_CURVES: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://0mlpjk6fpal6"),
	BuffableStats.DEF: preload("uid://qvxqkp482p5d"),
	BuffableStats.ATK: preload("uid://cj63tfqwliyle"),
	BuffableStats.WIS: preload("uid://crwii2iu22kwe")
}

const BASE_LEVEL_EXP: int = 100.0

signal health_depleted
signal health_changed(cur_health:float, max_health:float)

@export var faction: Faction = Faction.PLAYER
@export var base_max_health: float = 100.0
@export var base_def: float = 1.0
@export var base_atk: float = 1.0
@export var base_wis: float = 1.0
@export var experience: int = 0: set = _on_exp_set

var lvl: int:
	get(): return floor(max(1, sqrt(experience / BASE_LEVEL_EXP) +0.5))

var current_max_health: float = 100.0
var current_def: float = 1.0
var current_atk: float = 1.0
var current_wis: float = 1.0

var health: float = 0.0: set = _on_health_set
var def: float = 1.0
var atk: float = 1.0
var wis: float = 1.0

var stat_buffs: Array[StatBuff]

func _init() -> void:
	setup_stats.call_deferred()

func setup_stats() -> void:
	recalculate_stats()
	health = current_max_health
	def = current_def
	atk = current_atk
	wis = current_wis

func buff_add(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	recalculate_stats.call_deferred()

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	recalculate_stats.call_deferred()

func recalculate_stats() -> void:
	var stat_multipliers: Dictionary = {}
	var stat_addends: Dictionary = {}
	for buff in stat_buffs:
		var stat_name: String = BuffableStats.keys()[buff.stat].to_lower()
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount
				
			StatBuff.BuffType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name] = 1.0
				stat_multipliers[stat_name] += buff.buff_amount
	
	var stat_sample_pos: float = (float(lvl) / 100.0) - 0.01
	current_max_health = base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
	current_def = base_def * STAT_CURVES[BuffableStats.DEF].sample(stat_sample_pos)
	current_atk = base_atk * STAT_CURVES[BuffableStats.ATK].sample(stat_sample_pos)
	current_wis = base_wis * STAT_CURVES[BuffableStats.WIS].sample(stat_sample_pos)
	
	for stat_name in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])
		
	for stat_name in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])

func _on_health_set(new_value: float) -> void:
	health = clampf(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()

func _on_exp_set(new_value: int) -> void:
	var old_lvl: int = lvl
	experience = new_value
	
	if not old_lvl == lvl:
		recalculate_stats()

class_name Stats extends Resource
## Stat class for character entities

enum Faction {
	PLAYER,
	ENEMY
}

signal health_change(cur_health: float)
signal health_depleted

@export var faction: Faction = Faction.ENEMY
@export var max_health: float = 100.0
var health: float = max_health: set = _on_health_set

# Physical
@export var def: float = 0.0
@export var atk: float = 0.0

# Magical
@export var wis: float = 0.0
@export var intel: float = 0.0

func _on_health_set(new_health: float) -> void:
	health = clampf(new_health, 0, max_health)
	health_change.emit(health)
	if health == 0:
		health_depleted.emit()

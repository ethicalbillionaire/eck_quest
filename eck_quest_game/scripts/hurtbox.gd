class_name Hurtbox extends Area2D

@onready var owner_stats: Stats = owner.stats

func _ready() -> void:
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	match owner_stats.faction:
		Stats.Faction.PLAYER:
			set_collision_layer_value(6, true)
		
		Stats.Faction.ENEMY:
			set_collision_layer_value(5, true)
			
func receive_hit(damage: float) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(damage)
	print("hit received")

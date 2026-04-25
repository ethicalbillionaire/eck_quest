class_name HurtBox extends Area2D

@onready var _owner = get_parent()

func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	match _owner.stats.faction:
		Stats.Faction.PLAYER:
			set_collision_layer_value(6, true)
		
		Stats.Faction.ENEMY:
			set_collision_layer_value(5, true)
			
func receive_hit(payload: Payload) -> void:
	if _owner.has_method("take_damage"):
		_owner.take_damage(payload)

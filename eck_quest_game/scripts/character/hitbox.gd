class_name HitBox extends Area2D

var attacker_faction: int
var payload: Payload
var range: int
var shape: CollisionShape2D

func build_hitbox(_attacker_faction: int, _payload: Payload, _shape: CollisionShape2D) -> void:
	attacker_faction = _attacker_faction
	payload = _payload
	range = _payload.range
	shape = _shape

func _ready():
	monitorable = false
	area_entered.connect(_on_area_entered)
	
	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
		
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	match attacker_faction:
		Stats.Faction.PLAYER:
			set_collision_mask_value(6, true)
		
		Stats.Faction.ENEMY:
			set_collision_mask_value(5, true)

func _on_area_entered(area: Area2D) -> void:
	if not area.has_method("receive_hit"):
		return
	area.receive_hit(payload)

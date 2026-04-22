class_name Hitbox extends Area2D
## Hitbox class for projectiles
## 
## _init() expects:
##   AttackerStats: Stats,
##   Lifetime: int,
##   [Shape: Shape2D]

var attacker_stats: Stats
var lifetime: float
var shape: CollisionShape2D

func _init(_stats: Stats, _hitbox_lifetime: float, _shape: CollisionShape2D = null):
	attacker_stats = _stats
	lifetime = _hitbox_lifetime
	shape = _shape

func _ready():
	monitorable = false
	area_entered.connect(_on_area_entered)
	
	if lifetime > 0.0:
		var new_timer = Timer.new()
		add_child(new_timer)
		new_timer.timeout.connect(queue_free)
		new_timer.call_deferred("start", lifetime)
	
	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
		
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	match attacker_stats.faction:
		Stats.Faction.PLAYER:
			set_collision_mask_value(6, true)
		
		Stats.Faction.ENEMY:
			set_collision_mask_value(5, true)

func _on_area_entered(area: Area2D) -> void:
	print("projectile entered area")
	if not area.has_method("receive_hit"):
		return
	area.receive_hit(attacker_stats.atk)

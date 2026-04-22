extends CharacterBody2D

@export var SPEED = 300.0

var direction: Vector2
var attacker_stats: Stats
var lifetime: int = 2 # in seconds

func _ready() -> void:
	add_collision_exception_with(get_tree().get_first_node_in_group("player"))
	
func launch(spawn_pos: Vector2, dir: Vector2, stats: Stats) -> void:
	print("Arrow launched")
	# Hitbox creation
	var hit_box = Projectile.new(stats, lifetime)
	add_child(hit_box)
	
	# Launch direction
	global_position = spawn_pos
	direction = dir
	rotation = dir.angle() + deg_to_rad(90)
	
	# Lifetime timer
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	var collision = move_and_collide(velocity * delta)
	if collision:
		_on_hit(collision)

func _on_hit(collision: KinematicCollision2D) -> void:
	# deal damage
	queue_free()

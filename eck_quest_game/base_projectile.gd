extends Area2D

# Base projectile class

@export var SPEED = 300.0

var direction: Vector2
var attacker_stats: Stats
var lifetime: int = 2 # in seconds

func _ready() -> void:
	var hitshape: CollisionShape2D = $HitShape
	var hitbox: Hitbox = $Hitbox
	hitbox.shape = hitshape
	area_entered.connect(_on_hit)
	
func launch(spawn_pos: Vector2, dir: Vector2, stats: Stats) -> void:
	print("Arrow launched")	
	# Launch direction
	global_position = spawn_pos
	direction = dir
	rotation = dir.angle() + deg_to_rad(90)
	
	# Lifetime timer
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_hit(collision: KinematicCollision2D) -> void:
	# deal damage
	queue_free()

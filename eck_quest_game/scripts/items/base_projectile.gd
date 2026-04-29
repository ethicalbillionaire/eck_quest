class_name ProjectileBase extends Area2D

# Base projectile class

enum Faction {
	PLAYER,
	ENEMY
}

var speed = 700.0
var direction: Vector2
var attacker_stats: Stats
var attacker_faction: Faction
var _payload: Payload
var range: int = 100

var hitbox: HitBox
var hitbox_shape: CollisionShape2D
var _distance_traveled: float
var _spawn_pos: Vector2

func _ready() -> void:
	hitbox = get_child(0) # First child should be a HitBox node
	hitbox_shape = get_child(1) # Second child should be a CollisionShape2D
	area_entered.connect(_on_hit)
	
func launch(spawn_pos: Vector2, dir: Vector2, payload: Payload, player_stats: Stats) -> void:
	_spawn_pos = spawn_pos
	_payload = payload
	# Hitbox stuff
	hitbox.build_hitbox(player_stats.faction, _payload, hitbox_shape)
	# Launch direction
	global_position = _spawn_pos
	direction = dir
	rotation = dir.angle() + deg_to_rad(45)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	_distance_traveled = global_position.distance_to(_spawn_pos)
	if _distance_traveled >= _payload.range:
		queue_free()

func _on_hit(collision: Area2D) -> void:
	# deal damage
	queue_free()

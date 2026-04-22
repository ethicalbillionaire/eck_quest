extends Node

const Arrow = preload("res://scenes/arrow.tscn")

func _ready() -> void:
	get_tree().get_first_node_in_group("player").shoot_projectile.connect(_add_projectile)
	
func _add_projectile(spawn_pos: Vector2, dir: Vector2, player_stats: Stats, weapon: WeaponResource) -> void:
	var projectile = weapon.projectile.instantiate() # Projectile is a PackedScene
	add_child(projectile)
	projectile.launch(spawn_pos, dir)

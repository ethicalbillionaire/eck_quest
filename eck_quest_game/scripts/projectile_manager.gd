extends Node

var player_stats: Stats
var player_weapon: WeaponResource
var payload: Payload = Payload.new()

func _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	player.shoot_projectile.connect(_add_projectile)
	player.weapon_change.connect(_update_payload)
	player.stat_change.connect(_update_payload)
	player_stats = player.player_stats
	player_weapon = player.player_weapon
	_update_payload(player_stats, player_weapon)

func _update_payload(new_stats: Stats, new_weapon: WeaponResource = null) -> void:
	
	player_stats = new_stats
	if (new_weapon):
		player_weapon = new_weapon
		payload.range = player_weapon.range
		if (new_weapon.ignore_phy_res or new_weapon.ignore_mgc_res):
			payload.ignore_phy_res = new_weapon.ignore_phy_res
			payload.ignore_mgc_res = new_weapon.ignore_mgc_res
	
	print("Attack stat: {atk}".format({"atk":player_stats.atk}))
	print(player_stats.resource_path)
	payload.phy_damage = player_weapon.phy_dmg * (1 + (player_stats.atk * 0.01))
	payload.mgc_damage = player_weapon.mgc_dmg * (1 +(player_stats.wis * 0.01))
	

func _add_projectile(spawn_pos: Vector2, dir: Vector2) -> void:
	var new_projectile: ProjectileBase = player_weapon.projectile.instantiate() # Projectile is a PackedScene
	add_child(new_projectile)
	new_projectile.launch(spawn_pos, dir, payload, player_stats)

extends CharacterBody2D

@export var stats: Stats

var hurtbox: HurtBox

func _ready():
	$AnimatedSprite2D.play("idle")
	hurtbox = get_child(0)
	stats.def = 0
	stats.wis = 0

func _physics_process(delta: float) -> void:
	pass

func take_damage(payload: Payload):
	var total_dmg: float = calculate_damage(payload)
	show_damage(total_dmg)
	stats.health -= total_dmg

func calculate_damage(payload: Payload) -> float:
	const k = 50.0
	var phy_reduction: float = stats.def / (stats.def + k)
	var mgc_reduction: float = stats.wis / (stats.wis + k)
	var adjusted_phy_dmg: float = payload.phy_damage * (1 - phy_reduction)
	var adjusted_mgc_dmg: float = payload.mgc_damage * (1 - mgc_reduction)
	print("Raw damage: {phy} phy, {mgc} mgc".format({"phy":payload.phy_damage, "mgc":payload.mgc_damage}) )
	print("Damage reduction: {def} def, {wis} wis".format({"def": stats.def, "wis": stats.wis}))
	print("Adjusted damage: {a_phy} phy, {a_mgc} mgc".format({"a_phy": adjusted_phy_dmg, "a_mgc": adjusted_mgc_dmg}))
	print("Total Damage: {total} \n".format({"total":adjusted_phy_dmg + adjusted_mgc_dmg}))
	return adjusted_phy_dmg + adjusted_mgc_dmg
	

func show_damage(damage: float):
	var damage_number: Label = Label.new()
	damage_number.text = str(damage)
	add_child(damage_number)
	var rng = RandomNumberGenerator.new()
	var offset_x = rng.randi_range(-10, 0)
	damage_number.set_position(Vector2(offset_x, -30))
	var tween = get_tree().create_tween()
	tween.tween_property(damage_number, "position", Vector2(offset_x, -40), 1.0)
	tween.tween_callback(damage_number.queue_free)

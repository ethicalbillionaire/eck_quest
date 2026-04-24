extends CharacterBody2D

@export var stats: Stats
var hurtbox = HurtBox

func _ready():
	$AnimatedSprite2D.play("idle")
	var hurt_box = HurtBox.new()
	add_child(hurt_box)

func _physics_process(delta: float) -> void:
	pass

func take_damage(damage: float):
	print("Damage: {dmg}".format({"dmg":damage}) )
	stats.health -= damage

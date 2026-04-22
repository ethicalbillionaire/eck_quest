extends CharacterBody2D

@export var stats: Stats
var hurtbox = Hurtbox

func _ready():
	$AnimatedSprite2D.play("idle")
	var hurt_box = Hurtbox.new()

func _physics_process(delta: float) -> void:
	pass

func take_damage(damage: float):
	print("Damage: {dmg}".format({"dmg":damage}) )
	stats.health -= damage

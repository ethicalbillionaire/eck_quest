class_name Player extends CharacterBody2D

@export var player_stats: Stats
@export var player_weapon: WeaponResource = preload("uid://bha1kvkgd6abw")
@export var move_speed := 100.0

signal shoot_projectile(spawn_pos: Vector2, mouse_pos: Vector2)
signal weapon_change(player_stats: Stats, new_weapon: WeaponResource)
signal stat_change(player_stats: Stats)

var animated_sprite: AnimatedSprite2D
var move_direction: Vector2 = Vector2.DOWN
var attack_direction: Vector2 = Vector2.DOWN
var player_sm: LimboHSM
var projectile_timer: Timer

func _ready() -> void:
	animated_sprite = $AnimatedSprite2D
	player_stats.setup_stats()
	initiate_state_machine()
	
	# Setup rate of fire 
	projectile_timer = Timer.new()
	add_child(projectile_timer)
	projectile_timer.wait_time = 0.5
	projectile_timer.timeout.connect(_attack)
	projectile_timer.start()

#func _draw() -> void:
	#draw_line(Vector2.ZERO, get_local_mouse_position(), Color.RED)

func _physics_process(delta: float) -> void:
	#queue_redraw()
	# Movement
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	attack_direction = get_local_mouse_position()
	velocity = move_direction * move_speed
	move_and_slide()
	
	# Sprite orientation
	if player_sm.get_active_state().name == "attack":
		# Sprite should face mouse when attacking
		flip_sprite(attack_direction)
	else:
		flip_sprite(move_direction)

func flip_sprite(direction: Vector2) -> void:
	if direction.x > 0: #RIGHT
		animated_sprite.flip_h = false
	elif direction.x < 0: #LEFT
		animated_sprite.flip_h = true

func _attack() -> void:
	if not player_sm.get_active_state().name == "attack":
		return
	shoot_projectile.emit(self.global_position, (get_global_mouse_position()-self.position).normalized())

func initiate_state_machine() -> void:
	player_sm = LimboHSM.new()
	add_child(player_sm)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var walk_state = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	var attack_state = LimboState.new().named("attack").call_on_enter(attack_start).call_on_update(attack_update)
	
	player_sm.add_child(idle_state)
	player_sm.add_child(walk_state)
	player_sm.add_child(attack_state)
	
	player_sm.initial_state = idle_state
	
	player_sm.add_transition(player_sm.ANYSTATE, idle_state, &"state_ended")
	player_sm.add_transition(idle_state, walk_state, &"to_walk")
	player_sm.add_transition(idle_state, attack_state, &"to_attack")
	player_sm.add_transition(walk_state, attack_state, &"to_attack")
	
	player_sm.initialize(self)
	player_sm.set_active(true)
	
func idle_start() -> void:
	animated_sprite.play("idle")
func idle_update(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1"):
		player_sm.dispatch(&"to_attack")
	if velocity.x != 0 or velocity.y != 0:
		player_sm.dispatch(&"to_walk")
	animated_sprite.play("idle")

func walk_start() -> void:
	animated_sprite.play("walk")
func walk_update(delta: float) -> void:
	if Input.is_action_pressed("mouse1"):
		player_sm.dispatch(&"to_attack")
	if velocity.x == 0 and velocity.y == 0:
		player_sm.dispatch(&"state_ended")
	animated_sprite.play("walk")
	
func attack_start() -> void:
	animated_sprite.play("attack")
func attack_update(delta: float) -> void:
	if not Input.is_action_pressed("mouse1"):
		player_sm.dispatch(&"state_ended")
	animated_sprite.play("attack")

extends Node

const max_jump_held_time = 10.0 / 60.0
var has_double_jumped = false
var jump_held = 0

func enter(player: CharacterBody2D, _prevState):
	has_double_jumped = false
	jump_held = 0
	player.current_speed_cap = max(player.velocity.x, player.jump_min_max_speed)
	
	player.velocity.y = player.jump_velocity * 60

func process(player: CharacterBody2D, delta: float):
	if player.is_on_floor():
		return "idle"
	
	# TODO: maybe handle double jump differently?
	if Input.is_action_just_pressed("gameplay_jump") \
	and not has_double_jumped:
		player.velocity.y = player.jump_velocity * 60
		has_double_jumped = true
	
	player.handleMovement()
	if jump_held > max_jump_held_time:
		player.handleVerticalMovement(delta)
	else:
		if Input.is_action_pressed("gameplay_jump"):
			jump_held += delta
		else:
			jump_held = max_jump_held_time + delta

func physics_process(player: CharacterBody2D, _delta: float):
	player.move_and_slide()

extends State

const max_jump_held_time = 10.0 / 60.0
var has_double_jumped = false
var jump_held = 0

func enter(player: BasePlayer, _prevState, _delta):
	has_double_jumped = false
	jump_held = 0
	player.air_speed_cap = max(abs(player.velocity.x) / 60, player.jump_min_max_speed)
	
	player.animation_player.play("roll")
	player.velocity.y = player.jump_velocity * 60

func process(player: BasePlayer, delta: float):
	if player.is_on_floor():
		return "idle"
	
	# TODO: maybe handle double jump differently?
	if Input.is_action_just_pressed("gameplay_jump") \
	and not has_double_jumped:
		player.velocity.y = player.jump_velocity * 60
		has_double_jumped = true
	
	if jump_held <= max_jump_held_time:
		if Input.is_action_pressed("gameplay_jump"):
			jump_held += delta
		else:
			jump_held = max_jump_held_time + delta

func physics_process(player: BasePlayer, delta: float):
	player.handleMovement(delta)
	if jump_held > max_jump_held_time:
		player.handleVerticalMovement(delta)
	
	player.move_and_slide()

func exit(player: BasePlayer, _state, _delta):
	player.air_speed_cap = player.walkoff_max_speed

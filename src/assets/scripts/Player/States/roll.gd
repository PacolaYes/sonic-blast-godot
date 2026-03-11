extends State

func enter(player: BasePlayer, _prevState):
	player.animation_player.play("roll")

func process(player: BasePlayer, _delta: float):
	if player.velocity.x == 0:
		return "idle"
	
	if Input.is_action_just_pressed("gameplay_jump"):
		return "jump"

func physics_process(player: BasePlayer, delta: float):
	var velocity_direction = round(clamp(player.velocity.x, -1, 1))
	
	player.velocity.x -= player.roll_deacceleration * velocity_direction * 3600 * delta
	player.handleVerticalMovement(delta)
	
	player.move_and_slide()

extends State

var spindash = false

func enter(_player, _prevState, _delta):
	spindash = false

func process(player: BasePlayer, _delta):
	# Handle animation
	if spindash:
		player.animation_player.play("spindash")
	else:
		player.animation_player.play("crouch")
	
	var exit_state = "idle"
	if spindash:
		exit_state = "roll"
		
	if Input.is_action_just_pressed("gameplay_jump") \
	and not spindash:
		spindash = true
	
	if not Input.is_action_pressed("gameplay_down"):
		if spindash:
			var flip = 1 if player.sprite.flip_h else -1
			player.velocity.x = player.spindash_speed * 60 * flip
		
		return exit_state

func physics_process(player: BasePlayer, _delta: float):
	player.move_and_slide()

extends State

var maxspd_anim = false

func enter(_player: BasePlayer, _prevState):
	maxspd_anim = false

func process(player: BasePlayer, _delta: float):
	if not player.is_on_floor():
		player.animation_player.play("walk")
		return
	
	if Input.is_action_just_pressed("gameplay_jump"):
		return "jump"
	
	var isMoving = (abs(player.velocity.x) > 0)
	if Input.is_action_pressed("gameplay_down"):
		if isMoving:
			return "roll"
		return "crouch"
	
	var anim = "idle"
	if isMoving:
		player.sprite.flip_h = clampf(player.velocity.x, -1, 1) > 0
		if abs(player.velocity.x) >= player.run_anim_speed * 60:
			anim = "run"
		else:
			anim = "walk"
	elif Input.is_action_pressed("gameplay_up"):
		anim = "look up"
	
	player.animation_player.play(anim)

func physics_process(player: BasePlayer, delta: float):
	player.handleMovement(delta)
	if not player.is_on_floor():
		player.handleVerticalMovement(delta)
	
	player.move_and_slide()

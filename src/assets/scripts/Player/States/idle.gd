extends Node

func process(player: CharacterBody2D, delta: float):
	player.handleMovement()
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		return
	
	if Input.is_action_just_pressed("gameplay_jump"):
		return "jump"
	
	var isMoving = (abs(player.velocity.x) > 0)
	if Input.is_action_pressed("gameplay_down"):
		if isMoving:
			return "roll"
		return "crouch"
	
	if isMoving:
		player.sprite.flip_h = clampf(player.velocity.x, -1, 1) > 0

func physics_process(player: CharacterBody2D, _delta: float):
	player.move_and_slide()

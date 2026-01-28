extends Node

func enter(player: CharacterBody2D, _prevState):
	player.velocity.y = -player.jump_velocity

func process(player: CharacterBody2D, delta: float):
	if player.is_on_floor():
		return "idle"
	
	player.handleMovement()
	player.velocity += player.get_gravity() * delta

func physics_process(player: CharacterBody2D, _delta: float):
	player.move_and_slide()

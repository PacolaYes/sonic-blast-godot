extends State

func enter(player: BasePlayer, _prev_state: String):
	player.velocity.y = player.knockback_jump * 60
	player.animation_player.play("pain")
	player.invuln_time = player.invulnerability_tics
	pass

func process(player: BasePlayer, _delta: float):
	if player.is_on_floor():
		player.velocity.x = 0
		return "idle"

func physics_process(player: BasePlayer, delta: float):
	player.handleVerticalMovement(delta)
	player.move_and_slide()

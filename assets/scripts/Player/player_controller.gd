extends CharacterBody2D

@export var max_speed = 3.5 * 60
@export var acceleration = .875 * 60
@export var deacceleration = 1.75 * 60
@export var jump_velocity = 400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func handleMovement():
	var move_dir = round(Input.get_axis("gameplay_left", "gameplay_right"))
	var spd_dir = round(clamp(velocity.x, -1, 1))
	
	if move_dir \
	and move_dir == spd_dir or spd_dir == 0:
		velocity.x = move_toward(velocity.x, max_speed * move_dir, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deacceleration)

#func _process(delta: float) -> void:
	#pass
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * max_speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, max_speed)
#
	#move_and_slide()

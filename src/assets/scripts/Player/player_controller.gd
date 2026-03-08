extends CharacterBody2D

@export var max_speed := 3.5
@export var min_walk_speed := 0.0625
@export var run_speed := 2

@export var ground_acceleration := 0.03125
@export var ground_deacceleration := 0.09375 # deaccel for when you're not holding anything
@export var ground_back_deacceleration := 0.125 # deaccel for when you're moving back while moving, but not running
@export var skid_deacceleration := 0.078125 # deaccel for when you're skidding

@export var air_acceleration := 0.0625
@export var air_deacceleration := 0.03125
@export var walkoff_max_speed := 0.875

@export var jump_min_max_speed := 2.5
@export var jump_velocity := -5.25
@export var max_downwards_velocity := 4.5

@export var upwards_gravity := 0.25
@export var downwards_gravity := 0.375

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var air_speed_cap = 0

func handleMovement():
	var move_dir = round(Input.get_axis("gameplay_left", "gameplay_right"))
	var spd_dir = round(clamp(velocity.x, -1, 1))
	
	var accel = ground_acceleration
	var deaccel = ground_deacceleration
	var back_deaccel = ground_back_deacceleration
	if not is_on_floor():
		accel = air_acceleration
		back_deaccel = air_acceleration
		deaccel = air_deacceleration
	
	if move_dir:
		var use_accel = accel
		if move_dir != spd_dir:
			if abs(velocity.x) < run_speed \
			or not is_on_floor():
				use_accel = back_deaccel
			else:
				use_accel = skid_deacceleration
			
		velocity.x = move_toward(velocity.x, max_speed * 60 * move_dir, use_accel * 60)
		if abs(velocity.x) < min_walk_speed:
			velocity.x = min_walk_speed * 60 * move_dir
	else:
		velocity.x = move_toward(velocity.x, 0, deaccel * 60)

func handleVerticalMovement(delta):
	# TODO: maybe handle different gravity directions too??
	# even though i don't think people would want a sonic blast n' lost world fusion
	
	if velocity.y < 0:
		velocity.y += upwards_gravity * 3600 * delta
	else:
		velocity.y += downwards_gravity * 3600 * delta
	
	velocity.y = min(velocity.y, max_downwards_velocity * 60)

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

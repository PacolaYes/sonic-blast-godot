extends CharacterBody2D
class_name BasePlayer

@export var max_speed := 5.0
@export var run_speed := 3.5
@export var min_walk_speed := 0.0625
@export var run_anim_speed := 2
@export var spindash_speed := 4

@export var knockback_speed := 2
@export var knockback_jump := -4.5
@export var invulnerability_tics := 180

@export var ground_acceleration := 0.03125
@export var ground_deacceleration := 0.09375 # deaccel for when you're not holding anything
@export var ground_back_deacceleration := 0.125 # deaccel for when you're moving back while moving, but not running
@export var skid_deacceleration := 0.078125 # deaccel for when you're skidding
@export var roll_deacceleration := 0.015625

@export var air_acceleration := 0.0625
@export var air_deacceleration := 0.03125
@export var walkoff_max_speed := 0.875

@export var jump_min_max_speed := 2.5
@export var jump_velocity := -5.25
@export var max_downwards_velocity := 4.5

@export var upwards_gravity := 0.25
@export var downwards_gravity := 0.375

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collider_collision: CollisionShape2D = $BaseCollider/ColliderCollision

var air_speed_cap: float = walkoff_max_speed
var invuln_time: float = 0

func handleMovement(delta: float):
	var move_dir = round(Input.get_axis("gameplay_left", "gameplay_right"))
	var spd_dir = round(clamp(velocity.x, -1, 1))
	var grounded = is_on_floor()

	var maxspd = run_speed
	var accel = ground_acceleration
	var deaccel = ground_deacceleration
	var back_deaccel = ground_back_deacceleration
	if not grounded:
		maxspd = air_speed_cap
		accel = air_acceleration
		back_deaccel = air_acceleration
		deaccel = air_deacceleration
	
	if move_dir:
		var use_accel = accel
		if move_dir != spd_dir:
			if abs(velocity.x) < run_anim_speed \
			or not grounded:
				use_accel = back_deaccel
			else:
				use_accel = skid_deacceleration
			
		velocity.x = move_toward(velocity.x, maxspd * 60 * move_dir, use_accel * 3600 * delta)
		if abs(velocity.x) < min_walk_speed:
			velocity.x = min_walk_speed * 60 * move_dir
	else:
		velocity.x = move_toward(velocity.x, 0, deaccel * 3600 * delta)
	
	velocity.x = clamp(velocity.x, max_speed * -60, max_speed * 60)

func handleVerticalMovement(delta: float):
	# TODO: maybe handle different gravity directions too??
	# even though i don't think people would want a sonic blast n' lost world fusion
	
	if velocity.y < 0:
		velocity.y += upwards_gravity * 3600 * delta
	else:
		velocity.y += downwards_gravity * 3600 * delta
	
	velocity.y = min(velocity.y, max_downwards_velocity * 60)

func _process(delta: float) -> void:
	if invuln_time > 0:
		invuln_time -= 60 * delta
		
		collider_collision.disabled = true
		sprite.visible = fmod(invuln_time, 15) < 7.5
		if invuln_time < 0:
			sprite.visible = true
			collider_collision.disabled = false

func handle_damage(hitbox: BaseCollider):
	$StateMachine.changeState("pain")
	var mul = -1 if sprite.flip_h else 1
	velocity.x = knockback_speed * 60 * mul

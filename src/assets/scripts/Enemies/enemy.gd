extends CharacterBody2D # maaaaaybe CharacterBody2D isn't the best for an enemy but like. It Works.

@onready var sprite = $AnimatedSprite2D
@onready var collider = $BaseCollider/ColliderCollision

func death():
	process_mode = Node.PROCESS_MODE_DISABLED
	sprite.visible = false
	collider.disabled = true

func _ready():
	sprite.play("default")

func handle_damage(_hitbox: BaseCollider):
	death()

func _on_screen_entered() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	sprite.visible = true
	collider.disabled = false

func _on_screen_exited() -> void:
	death()

extends CharacterBody2D

func _ready():
	$AnimatedSprite2D.play("default")

func handle_damage(hitbox, hitboxed):
	queue_free()

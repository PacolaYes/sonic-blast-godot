extends Area2D
class_name Hurtbox

func _on_area_entered(hitbox: Hitbox):
	if owner.has_method("handle_damage"):
		owner.handle_damage(hitbox, hitbox.owner)

extends Area2D
class_name BaseCollider

enum collider_type {
	default,
	hitbox, # Generic Hitbox
	hurtbox, # Generic Hurtbox
	hitbox_and_hurtbox # Behaves as both a hitbox and a hurtbox, can hit other 'hitbox_hurtbox' if their parent's type is an 'enemy'.
}

@export var type: collider_type = collider_type.default
@export var parent_type: String = "base"

func _on_area_entered(collision: BaseCollider) -> void:
	if parent_type == collision.parent_type: # no friendlyfire
		return
	
	var doSame = true
	if type == collider_type.hitbox_and_hurtbox and collision.type == collider_type.hitbox_and_hurtbox:
		if parent_type != "enemy":
			doSame = false
	
	if (type == collider_type.hurtbox or type == collider_type.hitbox_and_hurtbox) and (collision.type == collider_type.hitbox or collision.type == collider_type.hitbox_and_hurtbox) and doSame \
	and owner.has_method("handle_damage"):
		owner.handle_damage(collision)

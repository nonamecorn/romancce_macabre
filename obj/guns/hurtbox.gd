extends Area2D

@export var damage := 10.0

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(damage, Vector2.LEFT.rotated(global_rotation) * -100)

func hurt():
	for body in get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt(damage, Vector2.ZERO)
	

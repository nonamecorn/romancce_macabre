extends Area2D

func set_radius(radius : float):
	$CollisionShape2D.shape.radius = radius

func bang():
	for body in get_overlapping_bodies():
		if body.has_method("alert"):
			body.alert(global_position)

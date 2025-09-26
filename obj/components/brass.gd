extends RigidBody2D

func _ready():
	apply_impulse(Vector2(-randf_range(400, 600), 0).rotated(global_rotation))
	#apply_torque_impulse(randf_range(2000, 4000))
	angular_velocity = randf_range(PI*8, PI*10) * sign(randf())

func _on_timer_timeout() -> void:
	queue_free()


func _on_fall_timer_timeout():
	set_collision_mask_value(2, true)

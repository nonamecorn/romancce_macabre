extends Sprite2D

@export var HANDLING_SPEED = 20.0
@export var weight_to_handle : Curve
@export var player_handled : bool
var look_pos = Vector2.ZERO
var current_target : Entity

func set_handling_spd(weight):
	if !weight: return
	HANDLING_SPEED = weight_to_handle.sample(weight)

func _physics_process(delta):
	if player_handled:
		look_pos = get_global_mouse_position()
	else:
		if current_target:
			look_pos = current_target.global_position + (current_target.velocity * delta)
	global_position = global_position.lerp(look_pos, delta * HANDLING_SPEED)

func apply_recoil(recoil_vector):
	var new_len = position.length() + recoil_vector.x
	global_position -= position - (position.normalized() * new_len).rotated(deg_to_rad(recoil_vector.y))

extends Node2D

class_name EntityHand

var flipped = false

func flip():
	get_parent().flip()
	flipped = !flipped
	scale.y *= -1

func _process(_delta: float) -> void:
	var cursor_pos = get_global_mouse_position()
	var pos = cursor_pos - global_position
	global_rotation = atan2(pos.y, pos.x)
	if cursor_pos.x < 0 and !flipped:
		flip()
	if cursor_pos.x >= 0 and flipped:
		flip()

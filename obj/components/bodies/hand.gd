extends Node2D

class_name EntityHand

var flipped = false

var pos := Vector2.ZERO

func flip():
	get_parent().flip()
	flipped = !flipped
	scale.y *= -1

func _process(_delta: float) -> void:
	var loc_pos = pos - global_position
	global_rotation = atan2(loc_pos.y, loc_pos.x)
	if loc_pos.x < 0 and !flipped:
		flip()
	if loc_pos.x >= 0 and flipped:
		flip()
	

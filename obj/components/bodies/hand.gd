extends Node2D

class_name EntityHand

@export var cursor : Node2D

var flipped = false

func flip():
	get_parent().flip()
	flipped = !flipped
	scale.y *= -1

func _process(_delta: float) -> void:
	var pos = cursor.global_position - global_position
	global_rotation = atan2(pos.y, pos.x)
	if cursor.position.x < 0 and !flipped:
		flip()
	if cursor.position.x >= 0 and flipped:
		flip()

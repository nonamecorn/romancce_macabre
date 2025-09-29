extends Control
class_name LineDrawer

@export var player_connectors: Array[Control]
@export var device_connectors: Array[Control]
@export var selected_player: int = 0
var line_color: Color = Color.WHITE
var line_selected_color: Color = Color.YELLOW

func _draw() -> void:
	for i in range(4):
		draw_line(player_connectors[i].global_position - global_position,
		device_connectors[GameSettings.player_to_device_id[i]].global_position - global_position,
		Color.YELLOW if i == selected_player else Color.WHITE, 4.0, true)

func _process(_delta):
	queue_redraw()

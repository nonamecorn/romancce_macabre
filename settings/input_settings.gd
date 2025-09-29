extends PanelContainer

@export var selected_player: int = 0
@export var selected_device: int = GameSettings.player_to_device_id[0]
@export var line_drawer: LineDrawer

func _on_player_select(extra_arg_0: int) -> void:
	selected_player = extra_arg_0
	if line_drawer:
		line_drawer.selected_player = extra_arg_0
	selected_device = GameSettings.player_to_device_id[extra_arg_0]

func _on_device_select(extra_arg_0: int) -> void:
	var swap_with_player = -1
	for i in range(4):
		if GameSettings.player_to_device_id[i] == extra_arg_0:
			if selected_player == i:
				return
			swap_with_player = i
			break
	if swap_with_player != -1:
		var device_temp = GameSettings.player_to_device_id[selected_player]
		GameSettings.player_to_device_id[selected_player] = extra_arg_0
		GameSettings.player_to_device_id[swap_with_player] = device_temp
	else:
		GameSettings.player_to_device_id[selected_player] = extra_arg_0

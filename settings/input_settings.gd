extends PanelContainer

## 0-index player selection
@export var selected_player: int = 0
@export var selected_device: int = GameSettings.player_to_device_id[0]

@export var line_drawer: LineDrawer
@export var line_color: Color = Color.WHITE
@export var line_selected_color: Color = Color.YELLOW

@onready var input_button_prefab: PackedScene = preload("res://settings/input_button.tscn")
@onready var action_list: VBoxContainer = $MarginContainer/HBoxContainer/Inputs/ScrollContainer/ActionList

func _ready() -> void:
	if line_drawer:
		line_drawer.line_color = line_color
		line_drawer.line_selected_color = line_selected_color
	_load_action_list(selected_player)

func _load_action_list(player_id: int = 0) -> void:
	for item in action_list.get_children():
		item.queue_free()

	for action in GameSettings.get_actions_by_player(player_id):
		var button = input_button_prefab.instantiate()
		var action_label = button.get_node(^"MarginContainer/HBoxContainer/LabelAction")
		var input_label = button.get_node(^"MarginContainer/HBoxContainer/LabelInput")

		action_label.text = action

		#var events = InputMap.action_get_events(action)
		#if events.size() > 0:
			#input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		#else:
			#input_label.text = "None"
		input_label.text = InputHelper.get_label_for_input(InputHelper.get_keyboard_input_for_action(action))

		action_list.add_child(button)

func _on_player_select(extra_arg_0: int) -> void:
	selected_player = extra_arg_0
	if line_drawer:
		line_drawer.selected_player = extra_arg_0
	selected_device = GameSettings.player_to_device_id[extra_arg_0]
	_load_action_list(extra_arg_0)

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
	# TODO load config
	_load_action_list(selected_player)

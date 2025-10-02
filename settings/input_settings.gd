extends PanelContainer

## 0-index player selection
@export var selected_player: int = 0
@export var selected_device: int = GameSettings.player_to_device_id[0]

@export var line_drawer: LineDrawer
@export var line_color: Color = Color.WHITE
@export var line_selected_color: Color = Color.YELLOW

@onready var action_list = $"MarginContainer/HBoxContainer/Inputs/ScrollContainer/ActionList"
@onready var player_list = $"MarginContainer/HBoxContainer/Players&Devices/PlayerList"
@onready var device_list = $"MarginContainer/HBoxContainer/Players&Devices/DeviceList"

@onready var input_button_prefab: PackedScene = preload("res://settings/input_button.tscn")
var _is_remapping: bool = false
var _action_to_remap: StringName
var _remapping_button: BaseButton

func _ready() -> void:
	_bind_buttons_pressed_to_idx(player_list, _on_player_select)
	_bind_buttons_pressed_to_idx(device_list, _on_device_select)
	if line_drawer:
		line_drawer.line_color = line_color
		line_drawer.line_selected_color = line_selected_color
	_on_player_select(selected_player)
	_load_action_list(selected_player)

## Binds button to a handler with it's idx as argument.
## [br]⚠ The container should only contain buttons, and they should be strictly in order for this to work.
func _bind_buttons_pressed_to_idx(container: Control, callable: Callable):
	for i in range(container.get_child_count()):
		var child = container.get_child(i)
		if child is BaseButton:
			(child as BaseButton).pressed.connect(callable.bind(i))

func _load_action_list(player_id: int = 0) -> void:
	for item in action_list.get_children():
		item.queue_free()

	for action in GameSettings.get_actions_by_player(player_id):
		var button: BaseButton = input_button_prefab.instantiate() as BaseButton
		var action_label = button.get_node(^"MarginContainer/HBoxContainer/LabelAction")
		var input_label = button.get_node(^"MarginContainer/HBoxContainer/LabelInput")
		
		## Strips the player prefix & capitalizes the action label.
		action_label.text = action.trim_prefix(GameSettings.PLAYER_ACTION_PREFIX % (player_id + 1)).capitalize()
		input_label.text = _get_input_label(action, player_id)

		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _get_input_label(action: StringName, player_id: int) -> String:
	var event: InputEvent = (InputHelper.get_keyboard_input_for_action(action)
			if GameSettings.player_to_device_id[player_id] == GameSettings.DeviceID.KEYBOARD_MOUSE
			else InputHelper.get_joypad_input_for_action(action))
	return InputHelper.get_label_for_input(event) if event else "None"

func _on_input_button_pressed(button: BaseButton, action: StringName) -> void:
	if !_is_remapping:
		_is_remapping = true
		_action_to_remap = action
		_remapping_button = button
		button.get_node(^"MarginContainer/HBoxContainer/LabelInput").text = "Press key to bind ..."

func _exit_remapping() -> void:
	_is_remapping = false
	_remapping_button.get_node(^"MarginContainer/HBoxContainer/LabelInput").text = _get_input_label(_action_to_remap, selected_player)

func _input(event: InputEvent) -> void:
	if !_is_remapping:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_exit_remapping()
		accept_event()
		return
	if ((GameSettings.player_to_device_id[selected_player] == (InputHelper.get_device_index_from_event(event) + 1)) and not ((event is InputEventJoypadMotion) and (abs(event.axis_value) < InputHelper.deadzone))):
		InputMap.action_erase_events(_action_to_remap)
		InputMap.action_add_event(_action_to_remap, event)
		_exit_remapping()
		GameSettings.serialize_player_input_dict(selected_player)
		GameSettings.dump_input_cfg()
		accept_event()

## Player button handler with 0-indexed [param player_id]
func _on_player_select(player_id: int) -> void:
	if _is_remapping:
		return
	selected_player = player_id
	if line_drawer:
		line_drawer.selected_player = player_id
	device_list.get_child(selected_device).button_pressed = false
	selected_device = GameSettings.player_to_device_id[player_id]
	device_list.get_child(selected_device).button_pressed = true
	
	_load_action_list(player_id)

## Device button handler with [enum GameSettings.DeviceID]
func _on_device_select(device_id: GameSettings.DeviceID) -> void:
	if _is_remapping:
		return
	var swap_with_player = -1
	for i in range(4):
		if GameSettings.player_to_device_id[i] == device_id:
			if selected_player == i:
				return
			swap_with_player = i
			break
	var device_temp = GameSettings.player_to_device_id[selected_player]
	GameSettings.player_to_device_id[selected_player] = device_id
	if swap_with_player != -1:
		GameSettings.player_to_device_id[swap_with_player] = device_temp
		_player_set_device_id(swap_with_player, device_temp)
	
	selected_device = device_id
	_player_set_device_id(selected_player, device_id)
	GameSettings.dump_input_cfg()
	_load_action_list(selected_player)

func _player_set_device_id(player_id: int, device_id: int) -> void:
	var actions = GameSettings.get_actions_by_player(player_id)
	GameSettings.player_to_device_id[player_id] = device_id
	GameSettings.apply_input_dict_for_player(player_id)
	for act in actions:
		var events = InputMap.action_get_events(act)
		for ev in events:
			if ev is InputEventJoypadButton or ev is InputEventJoypadMotion or ev is InputEventKey or ev is InputEventMouse:
				var new_ev := ev.duplicate()
				InputMap.action_erase_events(act)
				new_ev.device = device_id - 1 if not (new_ev is InputEventKey or new_ev is InputEventMouse) else -1
				InputMap.action_add_event(act, new_ev)
	GameSettings.serialize_player_input_dict(player_id)

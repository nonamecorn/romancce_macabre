extends Node

## Controls which players use which devices.
## The players are 0-indexed.
var player_to_device_id: Array[int] = [DeviceID.KEYBOARD_MOUSE, DeviceID.JOYSTICK_0, DeviceID.JOYSTICK_1, DeviceID.JOYSTICK_2]

var input_dict: Dictionary[String, String]

## We assume that we only have 1 keyboard 1 mouse and 4 joysticks
enum DeviceID {
	KEYBOARD_MOUSE = 0,
	JOYSTICK_0 = 1,
	JOYSTICK_1 = 2,
	JOYSTICK_2 = 3,
	JOYSTICK_3 = 4
}

const INPUT_CONFIG_PATH := "user://input.cfg"
const DEFAULT_INPUT_CONFIG_PATH := "res://settings/default_input.cfg"

func _ready() -> void:
	# _regenerate_default_input_cfg(); return
	var config_exists = FileAccess.file_exists(INPUT_CONFIG_PATH)
	if config_exists:
		var fa := FileAccess.open(INPUT_CONFIG_PATH, FileAccess.READ)
		config_exists = not fa.get_length() == 0
		fa.close()

	if not config_exists:
		print("No input.cfg config, loading the pregenerated default one from assets...")
		_load_input_cfg(DEFAULT_INPUT_CONFIG_PATH)
		dump_input_cfg()
	else:
		print("Loading input.cfg ...")
		_load_input_cfg()
		apply_input_dict()
	print("Successfully loaded input.cfg!")

## Loads the config into memory, but not applies it
func _load_input_cfg(path: String = "") -> void:
	if path.is_empty():
		path = INPUT_CONFIG_PATH
	var fa = FileAccess.open(path, FileAccess.READ)
	input_dict.clear()

	var cfg := fa.get_as_text().split("\n")
	for i in range(cfg.size()):
		cfg[i] = cfg[i].substr(0, cfg[i].find("#")) ## Comments removal
	var ids := cfg[0].split(";")

	assert(ids.size() - 1 >= player_to_device_id.size(), "Unable to parse_string player_to_device_id (too little players defined)")

	for i in player_to_device_id.size():
		player_to_device_id[i] = ids[i].to_int()

	for i in range(1, cfg.size()):
		if cfg[i].is_empty():
			continue
		var maps := cfg[i].split("=")
		assert(maps.size() == 2, "only 1 '=' per each line in a config")
		input_dict[maps[0]] = maps[1]
	fa.close()

func dump_input_cfg() -> void:
	var result := Array()
	var fa = FileAccess.open(INPUT_CONFIG_PATH, FileAccess.WRITE)

	var ptd := ""
	for i in range(player_to_device_id.size()):
		ptd += "%d;" % player_to_device_id[i]
	ptd += '# DeviceID, 0 is keyboard/mouse, 1 is Gamepad 0, 2 is Gamepad 1, etc...'
	result.append(ptd)

	for i in range(1, player_to_device_id.size() + 1):
		result.append("p%d_key=%s" % [i, input_dict["p%d_key" % i]])
		result.append("p%d_joy=%s" % [i, input_dict["p%d_joy" % i]])

	result.append("") ## For proper endline
	fa.store_string('\n'.join(result))
	fa.flush()
	fa.close()

## For embedding the [DEFAULT_INPUT_CONFIG_PATH] config file, EDITOR ONLY
func _regenerate_default_input_cfg() -> void:
	#assert(Engine.is_editor_hint(), "EDITOR ONLY CODE")

	print("Pregenerating %s" % DEFAULT_INPUT_CONFIG_PATH)
	var result := Array()
	var fa = FileAccess.open(DEFAULT_INPUT_CONFIG_PATH, FileAccess.WRITE)

	var ptd := ""
	for i in range(player_to_device_id.size()):
		ptd += "%d;" % player_to_device_id[i]
	ptd += '# DeviceID, 0 is keyboard/mouse, 1 is Gamepad 0, 2 is Gamepad 1, etc...'
	result.append(ptd)

	var key_default = InputHelper.serialize_inputs_for_actions(get_actions_by_player(0))
	result.append("p1_key=%s" % key_default)
	result.append("p1_joy=%s" % InputHelper.serialize_inputs_for_actions(get_actions_by_player(1)).replace("p2_", "p1_")) # Joy default
	for i in range(2, player_to_device_id.size() + 1):
		result.append("p%d_key=%s" % [i, key_default.replace("p1_", PLAYER_ACTION_PREFIX % i)])
		result.append("p%d_joy=%s" % [i, InputHelper.serialize_inputs_for_actions(get_actions_by_player(i - 1))])

	result.append("")
	fa.store_string('\n'.join(result))
	fa.flush()
	fa.close()

func apply_input_dict() -> void:
	for i in range(player_to_device_id.size()):
		apply_input_dict_for_player(i)

func _player_key_by_device(player_id: int) -> String:
	return ("p%d_key" if player_to_device_id[player_id] == 0 else "p%d_joy") % (player_id + 1)

func apply_input_dict_for_player(player_id: int) -> void:
	for act in get_actions_by_player(player_id):
		InputMap.action_erase_events(act)
		InputHelper.deserialize_inputs_for_actions(input_dict[_player_key_by_device(player_id)])

## @deprecated IDK why I made this but it should better not be used at all
func serialize_players_input_dict() -> void:
	for i in range(player_to_device_id.size()):
		serialize_player_input_dict(i)

func serialize_player_input_dict(player_id: int) -> void:
	input_dict[_player_key_by_device(player_id)] = InputHelper.serialize_inputs_for_actions(get_actions_by_player(player_id))

const PLAYER_ACTION_PREFIX = "p%d_" ## The actions should be in `"pX_action"` format
## Returns all action [StringName]s for a specific player.
## Converts the 0-index [param player_id] to a 1-index
func get_actions_by_player(player_id: int) -> Array[StringName]:
	player_id += 1
	return InputMap.get_actions().filter(func (x: StringName): return x.begins_with(PLAYER_ACTION_PREFIX % player_id))

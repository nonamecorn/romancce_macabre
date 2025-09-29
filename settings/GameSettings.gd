extends Node

## Controls which players use which devices.
## The players are 0-indexed.
var player_to_device_id: Array[int] = [DeviceID.KEYBOARD_MOUSE, DeviceID.JOYSTICK_0, DeviceID.JOYSTICK_1, DeviceID.JOYSTICK_2]

## We assume that we only have 1 keyboard 1 mouse and 4 joysticks
enum DeviceID {
	KEYBOARD_MOUSE = 0,
	JOYSTICK_0 = 1,
	JOYSTICK_1 = 2,
	JOYSTICK_2 = 3,
	JOYSTICK_3 = 4
}

func _ready() -> void:
	pass

const PLAYER_ACTION_PREFIX = "p%d" ## The actions should be in `"pX_action"` format
## Returns all action [StringName]s for a specific player.
## Converts the 0-index [param player_id] to a 1-index
func get_actions_by_player(player_id: int) -> Array[StringName]:
	player_id += 1
	return InputMap.get_actions().filter(func (x: StringName): return x.begins_with(PLAYER_ACTION_PREFIX % player_id))

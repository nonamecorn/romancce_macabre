extends Node

var player_to_device_id: Array[int] = [DeviceID.KEYBOARD_MOUSE, DeviceID.JOYSTICK_0, DeviceID.JOYSTICK_1, DeviceID.JOYSTICK_2]

enum DeviceID {
	KEYBOARD_MOUSE = 0,
	JOYSTICK_0 = 1,
	JOYSTICK_1 = 2,
	JOYSTICK_2 = 3,
	JOYSTICK_3 = 4
}

const PLAYER_ACTION_PREFIX = "p%d"
func events_by_player(pid: int) -> Array[StringName]:
	return InputMap.get_actions().filter(func (x: StringName): return x.begins_with(PLAYER_ACTION_PREFIX % pid))

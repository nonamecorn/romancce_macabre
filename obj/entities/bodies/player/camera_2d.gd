extends Camera2D

const MIN_ZOOM: float = 1.0
const MAX_ZOOM: float = 5.0
const ZOOM_RATE: float = 8.0
const ZOOM_INCREMENT: float = 0.1

var camera = Vector2.ZERO
var _target_zoom: float = 2.0

@export var cursor : Node2D
@export var scope : float = 15
@export var ads_enabled : bool = true

@export var r2 : float = 80
func _physics_process(delta):
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	#global_position = (get_parent().global_position + cursor.global_position) / 2
	var radius_vec = cursor.global_position - cursor.get_parent().global_position
	if radius_vec.length() > r2:
		position = radius_vec.normalized() * scope
	else: global_position = get_parent().global_position


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_out()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in()
#			if event.doubleclick:
#				focus_position(get_global_mouse_position())


func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)


func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)

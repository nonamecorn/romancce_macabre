extends Control

@export var settings := "res://settings/settings_menu.tscn"
@export var game = "res://game.tscn"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_on_quit_pressed()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(settings)

func _on_quit_pressed() -> void:
	get_tree().quit()

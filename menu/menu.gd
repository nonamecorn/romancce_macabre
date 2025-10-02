extends Control

@export var settings := "res://settings/settings_menu.tscn"
@export var game = "res://game.tscn"

func _ready() -> void:
	get_tree().paused = false
	if Score.global_score != 0:
		$"HBoxContainer/VBoxContainer/MarginScore/VBoxContainer".visible = true
		$"HBoxContainer/VBoxContainer/MarginScore/VBoxContainer/Total".text = str(Score.global_score)
		$"HBoxContainer/VBoxContainer/MarginScore/VBoxContainer/Max".text = str(Score.max_score)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_on_quit_pressed()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(settings)

func _on_quit_pressed() -> void:
	get_tree().quit()

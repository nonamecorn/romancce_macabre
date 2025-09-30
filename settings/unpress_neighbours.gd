extends Control


func _ready() -> void:
	for child in get_children():
		if child is BaseButton:
			(child as BaseButton).pressed.connect(_on_pressed.bind(child))

func _on_pressed(source: BaseButton) -> void:
	for child in get_children():
		if child is BaseButton:
			(child as BaseButton).button_pressed = child == source

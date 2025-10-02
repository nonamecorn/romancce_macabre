class_name OrderTicket
extends Control

@export var recipe: Recipe
@export var max_time: float = 90.0
@export var bar: ProgressBar
@onready var texture = $"ProgressBar/NinePatchRect/MarginContainer/VBoxContainer/recipe/HBoxContainer/Spacer2/Sprite2D"
@export var ingredients_textures: Array = [] ## Array of Sprite2D
@export var ingredients_count: Array = [] ## Array of Label
@export var actions_textures: Array = [] ## Array of Sprite2D


var time_left: float
signal expired(ticket: OrderTicket)

func _ready() -> void:
	time_left = max_time
	for step in $"ProgressBar/NinePatchRect/MarginContainer/VBoxContainer/ingredients".get_children():
		ingredients_textures.append(step.get_child(0)) # Step1/Sprite2D
		ingredients_count.append(step.get_child(1).get_child(0)) #Step1/MarginContainer/Label
	for step in $"ProgressBar/NinePatchRect/MarginContainer/VBoxContainer/action".get_children():
		actions_textures.append(step.get_child(0)) #Step1/Sprite2D
	_apply_recipe()
	pop_in()
	set_process(true)

func _apply_recipe() -> void:
	if recipe:
		texture.texture = recipe.texture
		for ing in recipe.inputs:
			pass
		bar.value = 1.0

func _process(delta: float) -> void:
	time_left -= delta
	bar.value = clamp(time_left / max_time, 0.0, 1.0)  # drain
	if time_left <= 0.0:
		expired.emit(self)

func pop_in() -> void:
	var tw := create_tween()
	self.scale = Vector2(0.9, 0.9)
	self.modulate.a = 0.0
	tw.tween_property(self, "scale", Vector2.ONE, 0.18)
	tw.parallel().tween_property(self, "modulate:a", 1.0, 0.18)

func pop_out_and_free() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.15)
	tw.tween_callback(queue_free)

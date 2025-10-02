class_name OrderTicket
extends Control

@export var recipe: Recipe
@export_range(1.0, 600.0, 0.1) var max_time: float = 90.0

var time_left: float
signal expired(ticket: OrderTicket)

func _ready() -> void:
	time_left = max_time
	_apply_recipe()
	pop_in()
	set_process(true)

func _apply_recipe() -> void:
	if recipe:
		%Icon.texture = recipe.icon
		%Name.text = recipe.display_name
		var box := %Ingredients as HBoxContainer
		for c in box.get_children(): c.queue_free()
		for ing in recipe.ingredients:
			var l := Label.new()
			l.text = str(ing)
			box.add_child(l)
		%Bar.min_value = 0.0
		%Bar.max_value = 1.0
		%Bar.value = 1.0  # full; we’ll drain to 0

func _process(delta: float) -> void:
	time_left -= delta
	%Bar.value = clamp(time_left / max_time, 0.0, 1.0)  # drain
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

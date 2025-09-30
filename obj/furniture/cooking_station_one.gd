extends StaticBody2D

class_name Station

var item : Item = null
@export var offset : Vector2 = Vector2(0, -24)

signal item_changed

func _on_input_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is Item:
		call_deferred("attach", body)

func attach(body : Item):
	if item or body.get_parent().name == "Item": return
	item = body
	body.freeze = true
	body.global_position = global_position + offset
	body.global_rotation = 0.0
	item_changed.emit()
	#await  get_tree().physics_frame
	


func _on_input_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	if body == item:
		item = null
		item_changed.emit()

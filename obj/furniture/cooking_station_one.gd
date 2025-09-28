extends StaticBody2D

var item : Item

func _on_input_body_entered(body: Node2D) -> void:
	if body is Item:
		call_deferred("attach", body)

func attach(body : Item):
	body.freeze = true
	body.global_position = global_position
	item = body


func _on_input_body_exited(body: Node2D) -> void:
	if body == item:
		item == null

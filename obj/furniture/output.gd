extends Station

func attach(body : Item):
	if item or body.get_parent().name == "Item": return
	item = body
	body.freeze = true
	body.global_position = global_position + offset
	body.global_rotation = 0.0
	item_changed.emit()
	#await  get_tree().physics_frame

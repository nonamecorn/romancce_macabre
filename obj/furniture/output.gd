extends Station


func attach(body : Item):
	if item or body.get_parent().name == "Item": return
	item = body
	body.freeze = true
	body.global_position = global_position + offset
	body.global_rotation = 0.0
	item_changed.emit()
	if body is Plate:
		check_orders(body.extract())
	#await  get_tree().physics_frame

func check_orders(ingr_res : IngredientRes):
	if ingr_res.id == "4":
		Score.score += 100

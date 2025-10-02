extends IngredientContainer

class_name Plate

func attach(body : Ingredient):
	if body.get_parent().name == "Item": return
	ingredients.append(body.res)
	body.queue_free()
	if !body.res.chopped:
		display(body.res.texture)
	else:
		display(body.res.chopped_tex)
	ingredients_changed.emit()

func display(texture: Texture):
	$sprite2.texture = texture

func extract() -> IngredientRes:
	$Sprite2D.frame = 1
	display(null)
	return ingredients.pop_front()

func throw(item):
	super(item)
	display(null)

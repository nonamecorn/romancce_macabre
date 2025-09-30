extends Item

class_name Ingredient

@export var res : IngredientRes

func _ready() -> void:
	$Sprite2D.texture = res.texture

func use():
	#regen_health
	pass

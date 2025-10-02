class_name Recipe
extends Resource

@export var id: StringName
@export var name: String = "recipe_default"
@export var texture: Texture
@export var inputs: Array[IngredientRes]
@export var outputs: Array[IngredientRes]
@export var duration: float = 1.0

func matches(given: Array[IngredientRes]) -> bool:
	var a := inputs.duplicate()
	a.sort_custom(IngredientRes.compare)
	var b := given.duplicate()
	b.sort_custom(IngredientRes.compare)
	return IngredientRes.equals_array(a, b)

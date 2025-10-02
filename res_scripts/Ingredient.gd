class_name IngredientRes
extends Resource

@export var id: StringName
@export var name: String
@export var texture: Texture
@export var chopped_tex: Texture
var chopped : bool = false

static func compare(a, b) -> bool:
	return a.id < b.id

static func equals(a, b) -> bool:
	return a.id == b.id

static func equals_array(a: Array[IngredientRes], b: Array[IngredientRes]) -> bool:
	if a.size() != b.size():
		return false
	for i in range(a.size()):
		if not equals(a[i], b[i]):
			return false
	return true

extends Item

class_name IngredientContainer

var ingredients : Array[IngredientRes] = []
var throw_force := 1000.0

signal ingredients_changed

func _ready() -> void:
	in_hand.connect(disable)
	out_hand.connect(enable)

func disable():
	$input/CollisionShape2D.set_deferred("disabled", true)

func enable():
	$input/CollisionShape2D.set_deferred("disabled", false)

func _on_input_area_entered(area: Node2D) -> void:
	var body = area.get_parent()
	if body == self: return
	if body is Ingredient:
		call_deferred("attach", body)

func attach(body : Ingredient):
	if body.get_parent().name == "Item": return
	ingredients.append(body.res)
	body.queue_free()
	ingredients_changed.emit()

func use():
	for item in ingredients:
		call_deferred("throw", item)
	ingredients_changed.emit()

func throw(item):
	ingredients.erase(item)
	var item_inst : Item = preload("res://obj/entity/ingredient.tscn").instantiate()
	item_inst.res = item
	item_inst.global_position = global_position + Vector2.RIGHT.rotated(global_rotation) * 32
	Main.current_level.add_child(item_inst)
	item_inst.apply_impulse(Vector2.RIGHT.rotated(global_rotation) * throw_force)

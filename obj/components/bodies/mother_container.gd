extends Item

var items : Array = []
var throw_force := 1000.0

func _ready() -> void:
	in_hand.connect(disable)
	out_hand.connect(enable)

func disable():
	$input/CollisionShape2D.set_deferred("disabled", true)

func enable():
	$input/CollisionShape2D.set_deferred("disabled", false)

func _on_input_body_entered(body: Node2D) -> void:
	if body == self: return
	if body is Item:
		call_deferred("attach", body)

func attach(body : Item):
	items.append(body.scene_file_path)
	body.queue_free()

func use():
	for item in items:
		call_deferred("throw", item)

func throw(item):
	items.erase(item)
	var item_inst : Item = load(item).instantiate()
	item_inst.global_position = global_position + Vector2.RIGHT.rotated(global_rotation) * 32
	Main.current_level.add_child(item_inst)
	item_inst.apply_impulse(Vector2.RIGHT.rotated(global_rotation) * throw_force)

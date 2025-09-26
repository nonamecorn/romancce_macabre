extends EntityHand

var weapon_equiped : int = 0

func _ready() -> void:
	main.inventory_changed.connect(_on_weapon_changed)

func _on_weapon_changed(inventory):
	if $Handmarker.get_child_count() > 0:
		$Handmarker.get_child(0).queue_free()
	if inventory.gun:
		load_weapon(inventory.gun.scene)

func load_weapon(scene : PackedScene):
	var weapon_inst = scene.instantiate()
	#weapon_inst.global_rotation = global_rotation
	weapon_inst.player_handled = true
	$Handmarker.add_child(weapon_inst)
	weapon_inst.global_position = $Handmarker.global_position

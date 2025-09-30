extends EntityHand

@export var player : CharacterBody2D

@export var throw_force = 1000
var item : RigidBody2D

func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed(player.moveset.pick):
		#print("dsgsf")
		if !has_item():
			pick_up()
		else:
			throw()
	if Input.is_action_just_pressed(player.moveset.use):
		if has_item():
			item.use()
	if Input.is_action_just_released(player.moveset.use):
		if has_item():
			item.stop_use()
func throw():
	#Main.current_level get_tree().current_scene
	item.out_hand.emit()
	item.reparent(Main.current_level)
	item.scale.y = 1
	item.freeze = false
	item.apply_impulse(($Handmarker.global_position - global_position).normalized() * throw_force)
	item = null

func pick_up():
	for area in $Handmarker/Area2D.get_overlapping_areas():
		if area.is_in_group("pickable"):
			var body = area.get_parent()
			body.reparent($Handmarker/Item)
			body.in_hand.emit()
			body.freeze = true
			if flipped:
				body.scale.y = scale.y * -1
			body.global_position = $Handmarker.global_position
			body.global_rotation = global_rotation
			item = body
			return

func has_item():
	return $Handmarker/Item.get_child_count() == 1

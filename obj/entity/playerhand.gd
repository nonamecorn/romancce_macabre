extends EntityHand

@export var player : CharacterBody2D

@export var throw_force = 1000
var has_item = false
var item : RigidBody2D

func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed(player.moveset.pick):
		#print("dsgsf")
		if !has_item:
			pick_up()
		else:
			call_deferred("throw")
			throw()
	if Input.is_action_just_pressed(player.moveset.use):
		if has_item:
			item.use()
	if Input.is_action_just_released(player.moveset.use):
		if has_item:
			item.stop_use()

func throw():
	#Main.current_level get_tree().current_scene
	Main.current_level.add_child(item)
	item.freeze = false
	item.apply_impulse(($Handmarker.global_position - global_position).normalized() * throw_force)
	item = null
	has_item = false

func pick_up():
	for body in $Handmarker/Area2D.get_overlapping_bodies():
		if body.is_in_group("pickable"):
			var body_inst = body
			body.queue_free()
			has_item = true
			body_inst.freeze = true
			body_inst.global_position = $Handmarker.global_position
			body_inst.rotation = 0.0
			Main.current_level.call_deferred("add_child", body_inst)
			item = body_inst
			return

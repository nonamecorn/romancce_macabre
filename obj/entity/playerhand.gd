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
			throw()

func throw():
	#Main.current_level get_tree().current_scene
	item.reparent(Main.current_level)
	item.freeze = false
	item.apply_impulse(($Handmarker.global_position - global_position).normalized() * throw_force)
	item = null
	has_item = false

func pick_up():
	for body in $Handmarker/Area2D.get_overlapping_bodies():
		if body.is_in_group("pickable"):
			has_item = true
			body.freeze = true
			body.global_position = $Handmarker.global_position
			body.reparent($Handmarker)
			item = body
			return

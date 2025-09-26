extends State

@export var inventory : Control

func enter():
	inventory.show()
func exit():
	inventory.hide()

func physics_update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		transitioned.emit(self,"walk")

extends FSM

@export var label : Control

func on_child_transition(state, new_state_name):
	super.on_child_transition(state, new_state_name)
	label.text = new_state_name

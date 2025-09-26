extends Node
class_name FSM

@export var initial_state : State

var states : Dictionary
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func force_transition(new_state_name):
	on_child_transition(current_state, new_state_name)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	#print(state, new_state_name)
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	#print(new_state_name)
	current_state = new_state

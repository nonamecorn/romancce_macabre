extends State

@export var player : Entity

func get_input_dir():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		transitioned.emit(self,"inventory")
	var input_vector = get_input_dir()
	if input_vector != Vector2.ZERO:
		player.velocity = player.velocity.move_toward(
			input_vector * player.MAX_SPEED,delta * player.ACCELERATION
			)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * player.ACCELERATION)
	player.move_and_slide()

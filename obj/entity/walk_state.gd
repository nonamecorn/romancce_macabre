extends State

@export var player : Entity

func get_input_dir():
	return Vector2(
		Input.get_axis(player.moveset.left, player.moveset.right),
		Input.get_axis(player.moveset.up, player.moveset.down)
	).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta):
	if !player.is_multiplayer_authority(): return
	var input_vector = get_input_dir()
	if input_vector != Vector2.ZERO:
		player.velocity = player.velocity.move_toward(
			input_vector * player.MAX_SPEED,delta * player.ACCELERATION
			)
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * player.ACCELERATION)
	player.move_and_slide()

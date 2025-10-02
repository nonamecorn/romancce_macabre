extends State

@export var player : Entity
@export var sprite : AnimatedSprite2D
func get_input_dir():
	return Input.get_vector(player.moveset.left, player.moveset.right, player.moveset.up, player.moveset.down)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta):
	var input_vector = get_input_dir()
	if input_vector != Vector2.ZERO:
		sprite.play("walk")
		player.velocity = player.velocity.move_toward(
			input_vector * player.MAX_SPEED,delta * player.ACCELERATION
			)
	else:
		sprite.play("idle")
		player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * player.ACCELERATION)
	player.move_and_slide()

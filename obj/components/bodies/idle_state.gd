extends State

@export var entity : Entity

func physics_update(delta):
	entity.velocity = entity.velocity.move_toward(Vector2.ZERO, delta * entity.ACCELERATION)
	entity.move_and_slide()

extends State

class_name DeathState

@export var entity : Entity
@export var sprite : AnimatedSprite2D
@export var hitbox_coll : CollisionShape2D
@export var wall_coll : CollisionShape2D
@export var hand : Node2D

func enter():
	entity.velocity = Vector2.ZERO
	sprite.rotate(PI/2)
	hitbox_coll.disabled = true
	wall_coll.disabled = true
	hand.hide()
	if entity is Player:
		hand.throw()

func exit():
	entity.velocity = Vector2.ZERO
	sprite.rotate(-PI/2)
	hitbox_coll.disabled = false
	wall_coll.disabled = false
	hand.show()

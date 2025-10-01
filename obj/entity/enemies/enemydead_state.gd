extends DeathState

@export var perceptor : Perceptor
@export var ray : RayCast2D

func enter():
	super.enter()
	perceptor.queue_free()
	ray.queue_free()

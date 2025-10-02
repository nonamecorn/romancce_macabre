extends DeathState

@export var perceptor : Perceptor
@export var ray : RayCast2D
@export var death_ingr : PackedScene
@export var hm : Marker2D

func enter():
	super.enter()
	Score.score += 10
	perceptor.queue_free()
	ray.queue_free()
	var ingr = death_ingr.instantiate()
	ingr.global_position = hm.global_position
	print(hm.global_position)
	get_parent().get_parent().get_parent().get_parent().call_deferred("add_child",ingr)
	ingr.global_position = hm.global_position

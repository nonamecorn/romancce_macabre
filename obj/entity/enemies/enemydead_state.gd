extends DeathState

@export var perceptor : Perceptor
@export var ray : RayCast2D
@export var death_ingr : IngredientRes

func enter():
	super.enter()
	perceptor.queue_free()
	ray.queue_free()
	var ingr = Ingredient.new()
	ingr.res = death_ingr
	ingr.global_position = entity.global_position
	get_parent().get_parent().add_child(ingr)

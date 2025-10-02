extends IngredientContainer

class_name Pot

@export var recipes : Array[Recipe]
var current_recipe : Recipe
var cook_tween : Tween

func matches(recipe : Recipe):
	return recipe.matches(ingredients)

func _ready() -> void:
	ingredients_changed.connect(match_recipe)

var heated : bool = false:
	set(value):
		heated = value
		if value:
			start_cooking()
		else:
			pause_cooking()

func match_recipe():
	print("aus")
	pause_cooking()
	$TextureProgressBar.value = 0.0
	var recipe_ind = recipes.find_custom(matches)
	if recipe_ind != -1:
		print("sa")
		current_recipe = recipes[recipe_ind]
		return true
	current_recipe = null
	return false

func start_cooking():
	if !current_recipe: return
	$TextureProgressBar.show()
	cook_tween = create_tween()
	cook_tween.tween_property($TextureProgressBar, "value", 100.0, current_recipe.duration)
	cook_tween.tween_callback(cooking_finished)

func pause_cooking():
	if cook_tween:
		cook_tween.kill()

func cooking_finished():
	$TextureProgressBar.hide()
	if match_recipe():
		ingredients = current_recipe.outputs

extends Item

class_name Ingredient

@export var res : IngredientRes
@export var health = 100

func _ready() -> void:
	print(global_position, "sag")
	if res.chopped:
		$Sprite2D.texture = res.chopped_tex
	else:
		$Sprite2D.texture = res.texture

func use():
	#regen_health
	pass

func hurt(damage, damage_vec):
	take_knockback(damage_vec)
	health -= damage
	if health <= 0:
		$Sprite2D.texture = res.chopped_tex
		res.chopped = true

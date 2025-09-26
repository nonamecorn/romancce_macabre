extends CharacterBody2D

class_name Entity

@export var MAX_SPEED = 100
@export var ACCELERATION = 700
@export var MAX_HP : float = 100
@export var group : String = "None"
var hp = MAX_HP
var flipped = false
@export var inventory = {
	"ARMOR": null,
	"HELMET": null,
	"WEAPON1": null,
	"BOLT1": null,
	"MAG1": null,
	"ATTACH1": null,
	"MUZZLE1": null,
	"WEAPON2": null,
	"BOLT2": null,
	"MAG2": null,
	"ATTACH2": null,
	"MUZZLE2": null,
}

func flip():
	flipped = !flipped
	$BodySprite.scale.x *= -1

func _on_hitbox_damaged(damage: float, damage_vec : Vector2) -> void:
	hp -= damage
	take_knockback(damage_vec)
	if hp <= 0:
		$FSM.force_transition("Dead")
func take_knockback(knock_vec : Vector2):
	
	velocity += knock_vec

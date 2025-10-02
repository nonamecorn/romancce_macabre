class_name Item
extends RigidBody2D

signal in_hand
signal out_hand



func use():
	pass
func stop_use():
	pass
func take_knockback(knock_vec: Vector2):
	linear_velocity += knock_vec
func hurt(_damage, damage_vec):
	take_knockback(damage_vec)

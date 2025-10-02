class_name Item
extends RigidBody2D

signal in_hand
signal out_hand



func use():
	$AnimationPlayer.play("kill")
func stop_use():
	$AnimationPlayer.stop()
func take_knockback(knock_vec: Vector2):
	linear_velocity += knock_vec
func hurt(_damage, damage_vec):
	take_knockback(damage_vec)

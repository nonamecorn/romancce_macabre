extends CharacterBody2D

class_name Projectile

@export var damage = 10.0
@export var speed : float = 500.0
@export var lifetime : float = 1.0
@export var velocity_to_scale : Curve
var move_vec : Vector2
var mod_vec : Vector2 = Vector2.ZERO
var enabled = true
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	move_vec = Vector2.RIGHT * speed
	move_vec = move_vec.rotated(global_rotation)
	#move_vec += mod_vec
	$Timer.wait_time = lifetime

func _physics_process(delta: float) -> void:
	if !enabled: return
	var coll = move_and_collide(move_vec * delta)
	if coll:
		on_collision(coll)

func angle_between_vector_and_line(vector: Vector2, line_normal: Vector2) -> float:
	# Normalize the vectors (important for dot product)
	var v_norm = vector.normalized()
	var n_norm = line_normal.normalized()
	# Calculate the angle between the vector and normal
	var angle_to_normal = rad_to_deg(v_norm.angle_to(n_norm))
	# The angle between vector and line is 90° minus that angle
	var angle_to_line = 90.0 - abs(angle_to_normal)
	return abs(angle_to_line)

func on_collision(coll):
	if coll.get_collider().has_method("hurt"):
		coll.get_collider().hurt(damage, coll.get_normal() * -100)
	elif angle_between_vector_and_line(move_vec, coll.get_normal()) < 15:
		move_vec /= 2
		move_vec = move_vec.bounce(coll.get_normal())
		return
	enabled = false

func _on_timer_timeout() -> void:
	queue_free()

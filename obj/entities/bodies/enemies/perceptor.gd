extends Node2D

class_name Perceptor

var bodies
var nearby_enemies
var nearby_allies
var visible_on_screen = false

@export var entity : Entity
@export var gun_marker : Node2D
@export var hand : Node2D
@export var ray : RayCast2D

@export var max_viev_distance = 600
@export var angle_cone_of_vission = 90

var previous_target : Entity = null
var target : Entity = null

signal enemy_spotted
signal lost_target
#signal target_changed
signal heard_smtng(pos : Vector2)

func alert(alert_pos):
	heard_smtng.emit(alert_pos)

func _physics_process(_delta: float) -> void:
	if randi_range(0,3) == 1: return
	bodies = get_tree().get_nodes_in_group("body")
	if update_current_target():
		enemy_spotted.emit()
	elif previous_target:
		lost_target.emit()

func update_current_target() -> bool:
	update_nearby_npcs()
	#print(target)
	#print($CQB_awareness.get_overlapping_bodies())
	#print(target in $CQB_awareness.get_overlapping_bodies())
	if is_instance_valid(target) and target in $CQB_awareness.get_overlapping_bodies():
		previous_target = target
		return true
	for enemy in nearby_enemies:
		#print(_in_vision_cone(enemy.global_position), " ", has_los(enemy))
		if _in_vision_cone(enemy.global_position) and has_los(enemy):
			previous_target = target
			target = enemy
			return true
	previous_target = target
	target = null
	return false

func update_nearby_npcs():
	nearby_allies = []
	nearby_enemies = []
	for body in bodies:
		if body.is_in_group(entity.group):
			nearby_allies.append(body)
		else:
			nearby_enemies.append(body)
	nearby_allies.sort_custom(sort_ascending)
	nearby_enemies.sort_custom(sort_ascending)
func dist(body):
	return global_position.distance_squared_to(body.global_position)
func sort_ascending(a : Entity, b : Entity):
	if dist(a) < dist(b):
		return true
	return false

func _in_vision_cone(point):
	var forward = (
		gun_marker.global_position - hand.global_position
		).normalized()
	var dir_to_point = point - hand.global_position
	
	return abs(rad_to_deg(dir_to_point.angle_to(forward))) <= angle_cone_of_vission

func has_los(los_target):
	#if !is_instance_valid(los_target): return false
	var ray_pos = gun_marker.get_child(0).get_pof()
	ray.global_position = ray_pos
	var vectooor = (
		los_target.global_position - ray_pos
		)
	ray.target_position = vectooor.normalized() * max_viev_distance
	ray.force_raycast_update()
	if ray.is_colliding() and ray.get_collider() == los_target:
		return true
	return false

func is_on_screen():
	return $VisibleOnScreenNotifier2D.is_on_screen()

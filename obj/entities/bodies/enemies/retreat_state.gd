extends State

@export var enemy: Node2D
@export var cover_searcher : Area2D
@export var nav_agent: NavigationAgent2D
@export var hand : Node2D
@export var cursor : Node2D
@export var retreat_length: float = 200.0
@export var perceptor : Perceptor

func _ready() -> void:
	hand.get_child(0).get_child(0).loaded.connect(loaded)

func loaded():
	transitioned.emit(self, "surround")

func enter():
	if !perceptor.target:
		transitioned.emit(self,"panic")
		return
	if cover_searcher.get_overlapping_bodies().size() == 0:
		var retreat_vec = (enemy.global_position - perceptor.target.global_position).normalized()
		enemy.set_movement_target(retreat_vec * retreat_length)

func physics_update(delta):
	if nav_agent.is_navigation_finished():
		transitioned.emit(self, "idle")
		return
	var current_pos = enemy.global_position
	var next_path = enemy.nav_agent.get_next_path_position()
	var new_velocity = (next_path - current_pos).normalized()
	enemy.velocity = enemy.velocity.move_toward(
	new_velocity * enemy.MAX_SPEED,delta * enemy.ACCELERATION
	)
	enemy.move_and_slide()
	cursor.look_pos = enemy.to_global(new_velocity * 5 + hand.position)

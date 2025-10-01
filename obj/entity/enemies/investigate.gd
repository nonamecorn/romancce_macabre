extends State

@export var enemy : CharacterBody2D
@export var nav_agent: NavigationAgent2D
@export var cursor : Node2D
@export var hand : Node2D
@export var hitbox : StaticBody2D
@export var perceptor : Perceptor

func _ready() -> void:
	perceptor.enemy_spotted.connect(spotted)
	perceptor.heard_smtng.connect(alert)
	#hitbox.damaged.connect(panic)

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func alert(pos):
	set_movement_target(pos)
#func panic(_damage, _damage_vec):
	#transitioned.emit(self, "panic")
func spotted():
	transitioned.emit(self, "surround")

func physics_update(delta):
	if nav_agent.is_navigation_finished():
		transitioned.emit(self, "patrol")
		return
	var current_pos = enemy.global_position
	var next_path = enemy.nav_agent.get_next_path_position()
	var new_velocity = (next_path - current_pos).normalized()
	enemy.velocity = enemy.velocity.move_toward(
	new_velocity * enemy.MAX_SPEED,delta * enemy.ACCELERATION
	)
	enemy.move_and_slide()
	cursor.look_pos = enemy.to_global(new_velocity * 5 + hand.position)

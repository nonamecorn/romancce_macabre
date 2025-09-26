extends State

@export var enemy : CharacterBody2D
@export var panic_speed : float
@export var cursor : Node2D
@export var hand : Node2D
@export var perceptor : Perceptor

var move_dir : Vector2 = Vector2.ZERO
var wander_time : float = 3.0

#func _ready() -> void:
	#perceptor.enemy_spotted.connect(spotted)
#
#func spotted():
	#transitioned.emit(self, "retreat")
func randomize_wander():
	move_dir = Vector2(randf_range(-1, 1),randf_range(-1, 1)).normalized()
	wander_time = randf_range(0.5, 2)

func enter():
	$Timer.start()
	randomize_wander()

func update(delta : float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta : float) -> void:
	if enemy:
		var coll = enemy.move_and_collide(move_dir * panic_speed * delta)
		if coll:
			move_dir = move_dir.bounce(coll.get_normal())
	cursor.look_pos = enemy.to_global(move_dir * 5 + hand.position)

func _on_panick_timer_timeout() -> void:
	transitioned.emit(self, "patrol")

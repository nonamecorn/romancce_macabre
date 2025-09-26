extends State

@export var enemy : CharacterBody2D
@export var cursor : Node2D
@export var hand : Node2D
@export var hitbox : StaticBody2D
@export var perceptor : Perceptor

var move_dir : Vector2 = Vector2.ZERO
var wander_time : float = 3.0

func _ready() -> void:
	perceptor.enemy_spotted.connect(spotted)
	perceptor.heard_smtng.connect(alert)
	hitbox.damaged.connect(panic)

func panic(_damage, damage_vec):
	enemy.set_movement_target(damage_vec.normalized() * -10)
	transitioned.emit(self, "panic")
func alert(pos):
	enemy.set_movement_target(pos)
	transitioned.emit(self, "investigate")
func spotted():
	transitioned.emit(self, "surround")

func randomize_wander():
	move_dir = Vector2(randf_range(-1, 1),randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func update(delta : float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta : float) -> void:
	if enemy:
		var coll = enemy.move_and_collide(move_dir * enemy.MAX_SPEED * delta)
		if coll:
			move_dir = move_dir.bounce(coll.get_normal())
	cursor.look_pos = enemy.to_global(move_dir * 5 + hand.position)

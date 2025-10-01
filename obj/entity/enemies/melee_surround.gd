extends State

@export var enemy: Node2D
@export var nav_agent: NavigationAgent2D
@export var hand : Node2D
@export var cursor : Node2D
@export var handmarker : Node2D
@export var perceptor : Perceptor

var last_known_position : Vector2

func _ready() -> void:
	handmarker.get_child(0).empty.connect(reloading)
	#handmarker.get_child(0).loaded.connect(reloading)
	perceptor.lost_target.connect(loss)

func loss():
	#print("loss")
	enemy.set_movement_target(last_known_position)
	transitioned.emit(self, "investigate")

func reloading():
	hand.get_child(0).get_child(0).reload()
	#transitioned.emit(self, "retreat")

func enter():
	if !perceptor.target:
		loss()
	$changepath.start()
	handmarker.get_child(0).start_fire()
	_on_changepath_timeout()

func exit():
	handmarker.get_child(0).stop_fire()
	$changepath.stop()

func get_circle_position(random) -> Vector2:
	var kill_circle_centre = perceptor.target.global_position
	var radius = 200
	var angle = random * PI * 2;
	return(kill_circle_centre + Vector2.RIGHT.rotated(angle) * radius)

func physics_update(delta):
	cursor.look_pos = perceptor.target.global_position
	if nav_agent.is_navigation_finished():
		_on_changepath_timeout()
	if !perceptor.target:
		return
		#state = INVESTIGATE
	last_known_position = perceptor.target.global_position
	var next_path = nav_agent.get_next_path_position()
	var new_velocity = (next_path - enemy.global_position).normalized()
	enemy.velocity = enemy.velocity.move_toward(
	new_velocity * enemy.MAX_SPEED,delta * enemy.ACCELERATION
	)
	enemy.move_and_slide()

func _on_attack_timeout() -> void:
	if perceptor.has_los(perceptor.target):
		handmarker.get_child(0).start_fire()
		$burst.start()

func _on_changepath_timeout() -> void:
	enemy.set_movement_target(get_circle_position(randf()))

func _on_burst_duration_timeout() -> void:
	handmarker.get_child(0).stop_fire()

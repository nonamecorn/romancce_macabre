class_name OrderManager
extends Node

@export var recipes: Array[Recipe]
@export var ticket_scene: PackedScene
@export var container_path: NodePath
@export var max_tickets: int = 5
@export var spawn_interval_sec := Vector2(6.0, 10.0)

var _rng := RandomNumberGenerator.new()
var _tickets: Array[OrderTicket] = []

signal order_spawned(ticket: OrderTicket)
signal order_completed(recipe: Recipe, score: int)
signal order_failed(recipe: Recipe, penalty: int)

func _ready() -> void:
	_rng.randomize()
	_schedule_next_spawn()

func _schedule_next_spawn() -> void:
	var wait := _rng.randf_range(spawn_interval_sec.x, spawn_interval_sec.y)
	var stt := get_tree().create_timer(wait)  # one-shot SceneTreeTimer
	stt.timeout.connect(func ():
		if _tickets.size() < max_tickets:
			_spawn_one()
		_schedule_next_spawn()
	)

func _spawn_one() -> void:
	if recipes.is_empty() or ticket_scene == null:
		push_warning("OrderManager: missing recipes or ticket_scene")
		return
	var recipe: Recipe = recipes[_rng.randi() % recipes.size()]
	var ticket: OrderTicket = ticket_scene.instantiate()
	ticket.recipe = recipe
	ticket.max_time = recipe.time_limit
	ticket.expired.connect(_on_ticket_expired.bind(ticket))
	(get_node(container_path) as Control).add_child(ticket)
	_tickets.append(ticket)
	order_spawned.emit(ticket)

func submit_ingredients(ingredients: PackedStringArray) -> bool:
	for t in _tickets:
		if t.recipe.matches(ingredients):
			_complete_ticket(t)
			return true
	return false

func _complete_ticket(t: OrderTicket) -> void:
	_tickets.erase(t)
	order_completed.emit(t.recipe, t.recipe.reward_score)
	t.pop_out_and_free()

func _on_ticket_expired(t: OrderTicket) -> void:
	_tickets.erase(t)
	order_failed.emit(t.recipe, t.recipe.fail_penalty)
	t.pop_out_and_free()

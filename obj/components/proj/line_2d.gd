extends Line2D

@export var enabled : bool = false

@export var MAX_LENGTH : int = 10

func _ready() -> void:
	add_point(get_parent().global_position)

func _physics_process(_delta: float) -> void:
	if !enabled: return
	add_point(get_parent().global_position)
	if get_point_count() > MAX_LENGTH:
		remove_point(0)

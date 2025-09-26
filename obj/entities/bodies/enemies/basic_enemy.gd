extends Entity

@export var nav_agent: NavigationAgent2D

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

extends StaticBody2D

var drop_pod : StaticBody2D

func load_pod(pod):
	print("huh")
	drop_pod = pod

func teleport(body):
	body.global_position = drop_pod.global_position + Vector2(0, 64)

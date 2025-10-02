extends Timer

func _ready():
	$TextureProgressBar/Label.text = str(wait_time)
	$TextureProgressBar.max_value = wait_time

func _process(delta: float) -> void:
	$TextureProgressBar.value = time_left
	$TextureProgressBar/Label.text = str(time_left)

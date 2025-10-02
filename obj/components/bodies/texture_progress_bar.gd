extends TextureProgressBar

func _ready():
	max_value = get_parent().hp
	get_parent().hp_changed.connect(change_value)

func change_value(n_value):
	value = n_value

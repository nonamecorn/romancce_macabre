extends Station

func _ready() -> void:
	item_changed.connect(heat)

func heat():
	if item is Pot:
		item.heated = true

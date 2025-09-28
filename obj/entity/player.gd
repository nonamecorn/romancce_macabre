extends Entity

@export var moveset : PlayerControls

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	$Label.text = name

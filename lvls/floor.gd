extends TileMapLayer

@export var world_layer : TileMapLayer

func _ready() -> void:
	for coord in get_used_cells():
		check_navigation(coord)

func check_navigation(coord):
	if world_layer.get_cell_source_id(coord) != -1:
		set_cell(coord,-1)

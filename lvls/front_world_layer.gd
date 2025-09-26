extends TileMapLayer

signal changed2

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint(): return
	changed2.emit()
	
	for wall_coord in get_used_cells_by_id(4):
		update_wall(wall_coord)
func update_wall(coord):
	if get_cell_source_id(coord - Vector2i(0, 1)) != 1:
		set_cell(coord,-1)

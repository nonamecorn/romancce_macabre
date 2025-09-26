extends TileMapLayer

@export var WorldLayer : TileMapLayer

var indexes := [
	Vector2i(0,3), # 0,0,0,0
	Vector2i(0,2), # 0,0,0,1
	Vector2i(3,3), # 0,0,1,0
	Vector2i(1,2), # 0,0,1,1
	Vector2i(0,0), # 0,1,0,0
	Vector2i(2,3), # 0,1,0,1
	Vector2i(3,2), # 0,1,1,0
	Vector2i(3,1), # 0,1,1,1
	Vector2i(1,3), # 1,0,0,0
	Vector2i(1,0), # 1,0,0,1
	Vector2i(0,1), # 1,0,1,0
	Vector2i(2,2), # 1,0,1,1
	Vector2i(3,0), # 1,1,0,0
	Vector2i(1,1), # 1,1,0,1
	Vector2i(2,0), # 1,1,1,0
	Vector2i(2,1), # 1,1,1,1
	]

func _ready() -> void:
	update_tiles()
	WorldLayer.changed2.connect(update_tiles)
	#print("0b0010".bin_to_int())

func update_tiles():
	clear()
	for cell_coord in WorldLayer.get_used_cells_by_id(1):
		stuff(cell_coord)
		stuff(cell_coord + Vector2i(1, 0))
		stuff(cell_coord + Vector2i(0, 1))
		stuff(cell_coord + Vector2i(1, 1))
		add_wall(cell_coord)

func add_wall(coord : Vector2i):
	if WorldLayer.get_cell_source_id(coord + Vector2i(0, 1)) == -1:
		WorldLayer.set_cell(coord + Vector2i(0, 1),4,Vector2i(0, 0))



func stuff(coord : Vector2i):
	var cell_coord1 = coord - Vector2i(1, 0)
	var cell_coord2 = coord - Vector2i(0, 1)
	var cell_coord3 = coord - Vector2i(1, 1)
	var flags = (str(int(WorldLayer.get_cell_source_id(coord) == 1)) +
	str(int(WorldLayer.get_cell_source_id(cell_coord1) == 1)) +
	str(int(WorldLayer.get_cell_source_id(cell_coord3) == 1)) +
	str(int(WorldLayer.get_cell_source_id(cell_coord2) == 1))).bin_to_int()
	#print(indexes[flags])
	set_cell(coord,0,indexes[flags])

#func _on_front_world_layer_changed() -> void:
	#print("huh")
	#update_tiles()

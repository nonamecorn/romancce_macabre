extends Node2D

var digger_count := 0
var floors : Array[Vector2i]

@export var pool : Array[PackedScene]

func _ready() -> void:
	wall_up()
	spawn_ememies()

func wall_up():
	floors = $floor.get_used_cells_by_id(0, Vector2i(1,1), 0)
	for tile_coords in floors:
		var atlas = $floor.get_cell_atlas_coords(tile_coords + Vector2i(0, -1))
		if (atlas == Vector2i(1,0) or
		 atlas == Vector2i(5,2) or
		atlas == Vector2i(6,2)
		):
			$walls.set_cell(tile_coords,1,Vector2i(0,0))

func spawn_ememies():
	for tile_coord in floors:
		if randf() > 0.02:
			continue
		pool.shuffle()
		var enemy_inst = pool[0].instantiate()
		enemy_inst.global_position = tile_coord * 32
		call_deferred("add_child", enemy_inst)

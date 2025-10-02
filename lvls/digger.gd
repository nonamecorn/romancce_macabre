extends Node2D

var cell_size : float = 32
@export var tilemap : TileMapLayer

@export var c_chance : float = 0.05
@export var c_growth : float = 0.3
@export var r_chance : float = 0.05
@export var r_growth : float = 0.3

var vectors = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

signal done

func _ready() -> void:
	vectors.shuffle()
	for i in 16:
		go()
	done.emit()

func dig():
	var room_w = 5
	var room_h = 5
	var cell_coord := tilemap.local_to_map(position)
	cell_coord -= Vector2i(room_w - 1, room_h -1)
	var cells: Array[Vector2i]
	for i in room_w:
		for j in room_h:
			cells.append(cell_coord + Vector2i(i,j))
	tilemap.set_cells_terrain_connect(cells, 0, 0)

func place_room():
	var room_w = randi_range(1, 3) * 3
	var room_h = randi_range(1,3) * 3
	var cell_coord := tilemap.local_to_map(position)
	cell_coord -= Vector2i(room_w / 2, room_h / 2)
	var cells: Array[Vector2i]
	for i in room_w:
		for j in room_h:
			cells.append(cell_coord + Vector2i(i,j))
	tilemap.set_cells_terrain_connect(cells, 0, 0)

func give_birth():
	vectors.shuffle()
	var cell_coord = tilemap.local_to_map(position)
	var digger = load("res://digger.tscn")
	var digger_inst = digger.instantiate()
	digger_inst.tilemap = tilemap
	digger_inst.position = position + vectors[0]*cell_size
	get_tree().current_scene.add_child(digger_inst)

func go():
	position += vectors[0] * cell_size * 2
	dig()
	if randf() < c_chance:
		vectors.shuffle()
		c_chance = 0.0
	else:
		c_chance += c_growth
	if randf() < r_chance:
		place_room()
		r_chance = 0.0
	else:
		r_chance += r_growth

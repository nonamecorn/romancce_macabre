extends Node
class_name ForestWorld

## 
@export_range(5, 16, 1) var size_power: int = 10

## If left as 0, the current seed would be unix_timestamp
@export var _seed: int = randi()
## Diamond–Square amplitude falloff
@export var ds_roughness: float = 0.82

## Elevation thresholds that split the world into 4 levels (strictly increasing)
@export var thresholds = PackedFloat32Array([0.15, 0.3])

## Rock & Sand pits Perlin knobs
@export var rock_frequency: float = 0.045
@export var rock_threshold: float = 0.65
@export var rock_atlas_coords := Vector2i(0, 1)
@export var sandrock_threshold: float = 0.3
@export var sandrock_atlas_coorss := Vector2i(0, 3)

@export var source_id: int = 0
## Tiles ordered by ascending height.
@export var atlas_coords = [
	Vector2i(0, 3), # Sand
	Vector2i(0, 2), # Dirt
	Vector2i(0, 0) # Grass
]

## Heightmap variables
var _height_map: PackedFloat32Array
var _size_linear: int
var _size_square: int

## Height bands
var bands: PackedInt32Array

## Tree heat map for Poisson Disc Sampling
var _tree_heat_map: PackedFloat32Array
@export var tree_distance_amp: float = 1024.0
@export var tree_min_distance: float = 192.0

func _ready() -> void:
	if _seed == 0:
		_seed = Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system(true))
	print(_seed)
	_size_square = (1 << size_power) + 1
	_size_linear = _size_square * _size_square
	_height_map.resize(_size_linear)
	bands.resize(_size_linear)
	## Wait for OS to gather some space for the array.
	call_deferred("_generate_and_paint")

## Get index from vector, assuming the array is a square matrix
func _2d_to_1d(x: int, y: int, size: int = _size_square) -> int:
	return y * size + x

## Main Generation function
func _generate_and_paint() -> void:
	var size = _size_square
	_height_map = _diamond_square(size, ds_roughness, _seed)
	_normalize_in_place(_height_map)
	var band = _banding(_height_map, thresholds)

	$Ground.clear()
	
	var noise = _get_new_perlin(_seed ^ 328561559, rock_frequency)
	
	_tree_heat_map = _height_map.duplicate()
	
	for y in range(size):
		for x in range(size):
			var level: int = band[_2d_to_1d(x, y)]
			var p = (noise.get_noise_2d(x, y)+1) * 0.5
			# Rock Sand Layer
			var is_rock = p > rock_threshold
			var is_sand = p < sandrock_threshold
			var tile: Vector2i
			if is_rock:
				tile = rock_atlas_coords
				_tree_heat_map[_2d_to_1d(x, y)] = INF
			elif is_sand:
				tile = sandrock_atlas_coorss
				_tree_heat_map[_2d_to_1d(x, y)] = INF
			# Main Terrain algorithm
			else:
				tile = atlas_coords[level]
				_tree_heat_map[_2d_to_1d(x, y)] = tree_min_distance + (1 - _tree_heat_map[_2d_to_1d(x, y)]) * tree_distance_amp
			$Ground.set_cell(
				Vector2i(x, y),
				source_id,
				tile
			)

## Returns Array of Array[float], normalized later.
func _diamond_square(size: int, roughness: float, seed_val: int) -> PackedFloat32Array:
	assert((size - 1) & (size - 2) == 0, "Size must be 2^k + 1.")
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_val

	_height_map[0] = rng.randf()
	_height_map[size - 1] = rng.randf()
	_height_map[_2d_to_1d(0, size - 1)] = rng.randf()
	_height_map[size * size - 1] = rng.randf()

	var step = size - 1
	var amp = 0.5

	while step > 1:
		var half = step >> 1

		# Diamond step
		for y in range(half, size - 1, step):
			for x in range(half, size - 1, step):
				var a = _height_map[_2d_to_1d(x - half, y - half)]
				var b = _height_map[_2d_to_1d(x + half, y - half)]
				var c = _height_map[_2d_to_1d(x - half, y + half)]
				var d = _height_map[_2d_to_1d(x + half, y + half)]
				var avg = (a + b + c + d) * 0.25
				_height_map[_2d_to_1d(x,y)] = avg + (rng.randf() * 2.0 - 1.0) * amp

		# Square step
		for y in range(0, size, half):
			for x in range((y + half) % step, size, step):
				var sum = 0.0
				var cnt = 0
				if y - half >= 0:
					sum += _height_map[_2d_to_1d(x, y - half)]; cnt += 1
				if y + half < size:
					sum += _height_map[_2d_to_1d(x, y + half)]; cnt += 1
				if x - half >= 0:
					sum += _height_map[_2d_to_1d(x - half, y)]; cnt += 1
				if x + half < size:
					sum += _height_map[_2d_to_1d(x + half, y)]; cnt += 1
				var avg = sum / float(cnt)
				_height_map[_2d_to_1d(x, y)] = avg + (rng.randf() * 2.0 - 1.0) * amp

		amp *= roughness
		step = half

	return _height_map

func _get_new_perlin(perlin_seed: int, freq: float) -> FastNoiseLite:
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = perlin_seed
	noise.frequency = freq
	return noise

func _normalize_in_place(heightmap: PackedFloat32Array) -> void:
	var _min: float = 1e20
	var _max: float = -1e20
	for v in heightmap:
		_min = min(_min, v)
		_max = max(_max, v)
	var span = max(_max - _min, 1e-6)
	print("span is %f, min %f, max %f" % [span, _min, _max])
	for v in range(_size_linear):
		heightmap[v] = clamp((heightmap[v] - _min) / span, 0.0, 1.0)

# Returns Array[Array[int]] based on thresholds
func _banding(heightmap: PackedFloat32Array, band_thresholds: PackedFloat32Array) -> Array:	
	for i in range(_size_linear):
		var v = heightmap[i]
		if v > 0.6:
			pass
		var idx = -1
		for t in range(band_thresholds.size()):
			if v <= band_thresholds[t]:
				idx = t
				break
		if idx == -1:
			idx = band_thresholds.size()
		bands[i] = idx
	return bands

extends Marker2D

enum directions {
	NORTH, EAST, SOUTH, WEST
}

@export var direction : directions

func get_inverse():
	match direction:
		directions.NORTH:
			return directions.SOUTH
		directions.EAST:
			return directions.WEST
		directions.SOUTH:
			return directions.NORTH
		directions.WEST:
			return directions.EAST

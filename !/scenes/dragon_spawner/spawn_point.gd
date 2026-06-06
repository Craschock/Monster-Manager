extends Marker3D

class_name SpawnPoint

enum Direction { NORTH, EAST, SOUTH, WEST }

## The direction the dragon is facing when spawning
@export var spawn_direction: Direction = Direction.SOUTH

func get_facing_angle() -> float:
	match spawn_direction:
		Direction.NORTH:
			return deg_to_rad(-90.0)
		Direction.EAST:
			return deg_to_rad(180.0)
		Direction.SOUTH:
			return deg_to_rad(90.0)
		Direction.WEST:
			return deg_to_rad(0.0)
	# All of the "Facing" is
	# derived from the gizmo in
	# the 3D Scene
	return 0.0

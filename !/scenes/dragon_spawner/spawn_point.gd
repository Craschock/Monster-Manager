extends StaticBody3D

class_name SpawnPoint

enum Direction { NORTH, EAST, SOUTH, WEST }

## The direction the dragon is facing when spawning
@export var spawn_direction: Direction = Direction.SOUTH

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var clickable_component: ClickableComponent = $ClickableComponent

func _ready() -> void:
	clickable_component.is_clickable = true
	clickable_component.on_click_callback = _on_click


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


func bought() -> void:
	mesh.visible = false
	clickable_component.is_clickable = false


func _on_click() -> void:
	Events.dragon_spawner_clicked.emit(self)

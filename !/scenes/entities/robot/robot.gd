extends CharacterBody3D

class_name Robot

var is_selected: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	var next_path_point := nav_agent.get_next_path_position()
	var new_velocity := (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	move_and_slide()
	
func set_target_position(position: Vector3):
	print("navigating to %s..." % position)
	nav_agent.target_position = position

func select():
	var color = Color.DARK_BLUE
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat
	
	
func deselect():
	var color = Color.SKY_BLUE
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("Robot sclicked")
			Events.robot_clicked.emit(self)

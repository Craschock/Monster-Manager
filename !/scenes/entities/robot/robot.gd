extends CharacterBody3D

class_name Robot

var is_selected: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

var speed: int = 5
var max_load: int = 1
var current_load: int = 0

func _physics_process(_delta: float) -> void:
	var next_path_point := nav_agent.get_next_path_position()
	var new_velocity := (next_path_point - global_position).normalized() * speed
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	move_and_slide()


func set_target_position(pos: Vector3):
	print("navigating to %s..." % pos)
	nav_agent.target_position = pos


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


func add_load() -> void:
	if current_load < max_load:
		current_load += 1


func remove_load() -> void:
	if current_load > 0:
		current_load -= 1


func full() -> bool:
	return current_load >= max_load


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("Robot sclicked")
			Events.robot_clicked.emit(self)

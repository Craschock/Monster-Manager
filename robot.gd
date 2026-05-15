extends CharacterBody3D

class_name Robot

signal robot_clicked(robot: Robot)

var is_selected: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var next_path_point := nav_agent.get_next_path_position()
	var new_velocity := (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	move_and_slide()
	
func set_target_position(position: Vector3):
	print("navigating to %s..." % position)
	nav_agent.target_position = position

func select():
	is_selected = true
	$Outline.visible = true
	
func deselect():
	is_selected = false
	$Outline.visible = false


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_pressed("select_click"):
			robot_clicked.emit(self)
				

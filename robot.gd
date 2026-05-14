extends CharacterBody3D

class_name Robot

@onready var box: CSGBox3D = $CSGBox3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	var next_path_point := nav_agent.get_next_path_position()
	var new_velocity := (next_path_point - global_position).normalized() * SPEED
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	move_and_slide()
	
func set_target_position(position: Vector3):
	print("navigating to %s..." % position)
	box.global_position = position
	nav_agent.target_position = position

extends Camera3D

@export var speed = 15.0
@export var angular_speed = 8.0

var source_rotation
var target_rotation
var elapsed

var previous_mouse_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(rotation)
	source_rotation = rotation.y
	target_rotation = rotation.y
	elapsed = 1.0
	previous_mouse_position = get_viewport().get_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# moving
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_up"):
		direction.z = -1.0
	if Input.is_action_pressed("move_down"):
		direction.z = 1.0
	if Input.is_action_pressed("move_left"):
		direction.x = -1.0
	if Input.is_action_pressed("move_right"):
		direction.x = 1.0
	# y coordinate is intentionaly left at zero
	
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)
	var velocity = direction * speed
	position += velocity * delta
	
	# moving with mouse
	var current_mouse_position = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var diff = current_mouse_position - previous_mouse_position
		var diff3d = Vector3(-diff.x, 0, -diff.y)
		diff3d = diff3d.rotated(Vector3.UP, rotation.y)
		position += diff3d * 0.03
	
	previous_mouse_position = current_mouse_position
	
	
	# rotating
	if elapsed >= 1.0:
		if Input.is_action_just_pressed("rotate_clockwise"):
			source_rotation = rotation.y
			target_rotation = source_rotation - PI/2
			elapsed = 0.0
		if Input.is_action_just_pressed("rotate_anticlockwise"):
			source_rotation = rotation.y
			target_rotation = source_rotation + PI/2
			elapsed = 0.0
	else:
		elapsed += delta * angular_speed
		elapsed = clampf(elapsed, 0.0, 1.0)
	
	rotation.y = lerp_angle(source_rotation, target_rotation, elapsed)


func _on_rotate_clockwise_pressed() -> void:
	Input.action_press("rotate_clockwise")
	Input.action_release("rotate_clockwise")

func _on_rotate_anti_clockwise_pressed() -> void:
	Input.action_press("rotate_anticlockwise")
	Input.action_release("rotate_anticlockwise")

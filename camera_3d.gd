extends Camera3D

var robot: Robot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# using group instead?
	robot = $"../Robot"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("move_click"):
			var target = get_target_position(event)
			if target:
				robot.set_target_position(target)
			
func get_target_position(event: InputEventMouseButton):
	print(event.position)
	var from = self.project_ray_origin(event.position)
	print(from)
	var direction = self.project_ray_normal(event.position)
	print(direction)

	var plane = Plane(Vector3.UP, 0.0)
	var position = plane.intersects_ray(from, direction)
	
	print(position)
	return position

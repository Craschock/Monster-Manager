extends Node3D

var mesh: MeshInstance3D
var task_timer: Timer
var time_coefficients: Dictionary
var reward_coefficients: Dictionary
var current_task: Task

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh = $Model/MeshInstance3D
	task_timer = $TaskTimer
	# coefficients should be set by spawner
	time_coefficients = {
		Task.Type.TYPE1 : 0.5,
		Task.Type.TYPE2 : 1,
		Task.Type.TYPE3 : 1,
	}
	reward_coefficients = {
		Task.Type.TYPE1 : 2,
		Task.Type.TYPE2 : 1,
		Task.Type.TYPE3 : 1,
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("entered")
	
	# detect what kind of prop or task was delivered
	if body is Robot:
		print("Robot entered")
		var robot = body as Robot
		var task = robot.current_task
		if task != null:
			handle_new_task(task)
			robot.current_task = null
		else:
			print("nothing to be done")
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	mesh.material_override = mat


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("exited")
	
	if body is Robot:
		print("Robot exited")
		
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.GREEN
	mesh.material_override = mat
	

func handle_new_task(task: Task) -> void:
	current_task = task
	var type = task.type
	var time = task.time_to_complete * time_coefficients[type]
	print("Starting timer with time ", time)
	task_timer.start(time)


func _on_task_timer_timeout() -> void:
	var type = current_task.type
	var reward = current_task.reward * reward_coefficients[type]
	print("Received reward ", reward)  # this will instead emit probably
	

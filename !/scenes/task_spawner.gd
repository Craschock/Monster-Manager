extends Node

const Task1Scn = preload("res://!/scenes/tasks/task_1.tscn")
const Task2Scn = preload("res://!/scenes/tasks/task_2.tscn")
const Task3Scn = preload("res://!/scenes/tasks/task_3.tscn")

const TYPE_TO_SCN: Dictionary[Task.Type, PackedScene] = {
	Task.Type.TYPE1 : Task1Scn,
	Task.Type.TYPE2 : Task2Scn,
	Task.Type.TYPE3 : Task3Scn,
}

const CAPACITY = 3

var type_to_sp: Dictionary[Task.Type, Area3D]
var tasks: Dictionary[Task.Type, Array]

func _ready() -> void:
	var spawn_point1: Area3D = $Task1SpawnPoint
	var spawn_point2: Area3D = $Task2SpawnPoint
	var spawn_point3: Area3D = $Task3SpawnPoint
	type_to_sp = {
		Task.Type.TYPE1 : spawn_point1,
		Task.Type.TYPE2 : spawn_point2,
		Task.Type.TYPE3 : spawn_point3,
	}
	tasks = {
		Task.Type.TYPE1 : [],
		Task.Type.TYPE2 : [],
		Task.Type.TYPE3 : [],
	}


func _on_new_task_timer_timeout() -> void:
	create_new_task()


func create_new_task() -> void:
	# pick random type
	var type = Task.Type.values().pick_random()
	if tasks[type].size() == CAPACITY:
		return
	
	var scn = TYPE_TO_SCN[type]
	var task: Task = scn.instantiate()
	var spawn_point = type_to_sp[type]
	task.position = spawn_point.position
	add_child(task)
	
	tasks[type].push_back(task)


func _on_spawn_point_body_entered(body: Node3D, type: Task.Type) -> void:
	if body is Robot:
		var robot = body as Robot
		if !tasks[type].is_empty() and !robot.full():
			var task: Task = tasks[type].pop_back()
			task.carrier = robot
			robot.add_load()


func _on_task_1_spawn_point_body_entered(body: Node3D) -> void:
	_on_spawn_point_body_entered(body, Task.Type.TYPE1)


func _on_task_2_spawn_point_body_entered(body: Node3D) -> void:
	_on_spawn_point_body_entered(body, Task.Type.TYPE2)


func _on_task_3_spawn_point_body_entered(body: Node3D) -> void:
	_on_spawn_point_body_entered(body, Task.Type.TYPE3)

extends Node

const TaskScn = preload("res://!/scenes/task.tscn")

# instead of colors, use models
const TYPE_TO_MODEL = {
	Task.Type.TYPE1 : Color.WEB_GREEN,
	Task.Type.TYPE2 : Color.YELLOW,
	Task.Type.TYPE3 : Color.HOT_PINK,
}

const CAPACITY = 3

var type_to_sp: Dictionary[Task.Type, Area3D]
var tasks: Dictionary[Task.Type, Array]

func _ready() -> void:
	var spawn_point1: Area3D = $Task1SpawnPoint
	var spawn_point2: Area3D = $Task2SpawnPoint
	var spawn_point3: Area3D = $Task3SpawnPoint
	assert(TYPE_TO_MODEL.size() == Task.Type.size())
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
	
	var task: Task = TaskScn.instantiate()
	task.initialize(5, 100, type)
	var color = TYPE_TO_MODEL[type]
	var spawn_point = type_to_sp[type]
	task.position = spawn_point.position
	task.visible = false
	add_child(task)
	task.set_color(color)
	task.visible = true
	
	tasks[type].push_back(task)


func _on_spawn_point_body_entered(body: Node3D, type: Task.Type) -> void:
	if body is Robot:
		var robot = body as Robot
		if !tasks[type].is_empty():
			var task: Task = tasks[type].pop_back()
			task.carrier = robot


func _on_task_1_spawn_point_body_entered(body: Node3D) -> void:
	_on_spawn_point_body_entered(body, Task.Type.TYPE1)


func _on_task_2_spawn_point_body_entered(body: Node3D) -> void:
	_on_spawn_point_body_entered(body, Task.Type.TYPE2)


func _on_task_3_spawn_point_body_entered(body: Node3D) -> void:
	_on_spawn_point_body_entered(body, Task.Type.TYPE3)

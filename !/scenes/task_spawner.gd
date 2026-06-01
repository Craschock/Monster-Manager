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
var task_counts: Dictionary[Task.Type, int]

func _ready() -> void:
	var spawn_point1: Area3D = $Task1SpawnPoint
	var spawn_point2: Area3D = $Task2SpawnPoint
	var spawn_point3: Area3D = $Task3SpawnPoint
	type_to_sp = {
		Task.Type.TYPE1 : spawn_point1,
		Task.Type.TYPE2 : spawn_point2,
		Task.Type.TYPE3 : spawn_point3,
	}
	task_counts = {
		Task.Type.TYPE1 : 0,
		Task.Type.TYPE2 : 0,
		Task.Type.TYPE3 : 0,
	}
	
	Events.item_picked_up.connect(on_item_picked_up)


func _on_new_task_timer_timeout() -> void:
	create_new_task()


func create_new_task() -> void:
	# pick random type
	var type = Task.Type.values().pick_random()
	if task_counts[type] >= CAPACITY:
		return
	
	var scn = TYPE_TO_SCN[type]
	var task: Task = scn.instantiate()
	var spawn_point = type_to_sp[type]
	task.position = spawn_point.position
	add_child(task)
	task_counts[type] += 1


func on_item_picked_up(item):
	if item is Task:
		var task = item as Task
		var type = task.type
		task_counts[type] -= 1

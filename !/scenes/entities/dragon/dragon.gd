extends Node3D

class_name Dragon

signal dragon_leaving(dragon: Dragon)

var current_task: Task = null
var time_coefficients: Dictionary[Task.Type, float]
var reward_coefficients: Dictionary[Task.Type, float]
var completed_tasks: int = 0
var max_tasks: int = 3
# todo mood

@onready var task_timer: Timer = $TaskTimer
@onready var task_progression: Label3D = $TaskPrograssion


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_task:
		var time_left = task_timer.time_left
		var time_total = task_timer.wait_time
		var progression = 1.0 - (time_left / time_total)
		task_progression.text = "%s %%" % int(progression * 100)


func _on_model_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Events.dragon_clicked.emit(self)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Task:
		handle_new_task(body as Task)


func handle_new_task(task: Task) -> void:
	if current_task == null:
		var carrier = task.carrier
		task.carrier = null
		carrier.remove_load()
		start_task(task)


func start_task(task: Task) -> void:
	current_task = task
	var type = task.type
	var time = time_coefficients[type] * task.time_to_complete
	task_timer.start(time)
	task_progression.visible = true


func _on_task_timer_timeout() -> void:
	var type = current_task.type
	var reward = reward_coefficients[type] * current_task.reward
	# todo show to player
	# todo increase currency
	print("Receiving reward ", reward)
	task_progression.visible = false
	current_task.queue_free()
	current_task = null
	completed_tasks += 1
	if completed_tasks == max_tasks:
		leave()
	


func leave() -> void:
	dragon_leaving.emit(self)
	queue_free()

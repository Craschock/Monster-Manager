extends Node3D

class_name Dragon

signal dragon_leaving(dragon: Dragon)

var current_task: Task = null
var time_coefficients: Dictionary[Task.Type, float]
var reward_coefficients: Dictionary[Task.Type, float]
var completed_tasks: int = 0
var max_tasks: int = 3
var mood: int = 100

@onready var task_timer: Timer = $TaskTimer
@onready var task_progression: Label3D = $TaskPrograssion
@onready var mood_timer: Timer = $MoodTimer
@onready var mood_label: Label3D = $MoodLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_task:
		var time_left = task_timer.time_left
		var time_total = task_timer.wait_time
		var progression = 1.0 - (time_left / time_total)
		task_progression.text = "%s %%" % int(progression * 100)
	
	var mood_str: String = ""
	if mood > 70:
		mood_str = ":D"
	elif mood > 30:
		mood_str = ":/"
	else:
		mood_str = ">:("
	mood_label.text = mood_str
	


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Events.dragon_clicked.emit(self)


func handle_new_item(item, carrier: Robot):
	if item is Task:
		start_task(item as Task, carrier)
	if item is Prop:
		process_prop(item as Prop)


func start_task(task: Task, carrier: Robot) -> void:
	var r = randi_range(-30, 50)  # todo tweak values
	if r > mood:  # lower mood -> higher probability of eating
		# eat carrier
		carrier.die()
		return
	
	# todo: what if dragon is already working on task?
	#	current: discard current, start new
	#	alt: task queue
	#	alt: task is left at robot
	current_task = task
	var type = task.type
	var time = time_coefficients[type] * task.time_to_complete
	task_timer.start(time)
	task_progression.visible = true
	task.input_ray_pickable = false


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


func process_prop(prop: Prop):
	mood += prop.mood_boost
	mood = clamp(mood, 0, 100)
	prop.queue_free()


func leave() -> void:
	dragon_leaving.emit(self)
	queue_free()


func _on_mood_timer_timeout() -> void:
	mood -= 10
	if mood < 0:
		leave()

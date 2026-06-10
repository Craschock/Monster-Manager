extends Node3D

class_name Dragon

signal dragon_leaving(dragon: Dragon)

enum AnimState { SLEEP, DESTROYSITL, DESTROYSITR, DRAGONSBREATH, DRINKING_COFFE, STAMPING, TAKEPHONE, CALL, WORK, WALK }

const ANIM_STRINGS = {
	AnimState.SLEEP: "Sleep",
	AnimState.DESTROYSITL: "DestroySitL",
	AnimState.DESTROYSITR: "DestroySitR",
	AnimState.DRAGONSBREATH: "DragonsBreath_001",
	AnimState.DRINKING_COFFE: "Drinking Coffee Sit",
	AnimState.STAMPING: "Stamping",
	AnimState.TAKEPHONE: "TakePhone",
	AnimState.CALL: "Call",
	AnimState.WORK: "Work",
	AnimState.WALK: "Walk"
}

const ICON_MOOD1 = preload("res://!/assets/Sprites/MoodIcon_1.png")
const ICON_MOOD2 = preload("res://!/assets/Sprites/MoodIcon_2.png")
const ICON_MOOD3 = preload("res://!/assets/Sprites/MoodIcon_3.png")

@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree
@export var time_coefficients: Dictionary[Task.Type, float]
@export var reward_coefficients: Dictionary[Task.Type, float]

var current_task: Task = null
var completed_tasks: int = 0
var max_tasks: int = 3
var mood: int = 100

@onready var task_timer: Timer = $TaskTimer
@onready var state_machine = anim_tree.get("parameters/playback") if anim_tree else null
@onready var task_progression: Sprite3D = $TaskProgressionFrame
@onready var task_bars: Array[TextureProgressBar] = [
	$TaskProgressionFrame/SubViewport/TaskType1/Task1_Fill,
	$TaskProgressionFrame/SubViewport/TaskType2/Task2_Fill,
	$TaskProgressionFrame/SubViewport/TaskType3/Task3_Fill
]
@onready var mood_sprites: Array[Sprite3D] = [
	$Moods/Mood_1,
	$Moods/Mood_2,
	$Moods/Mood_3
]
@onready var clickable_component: ClickableComponent = $ClickableComponent

# Initial idle anim
func _ready() -> void:
	play_anim(AnimState.SLEEP)
	_set_clickability()
	clickable_component.on_click_callback = _on_click
	RobotState.robot_state_changed.connect(_set_clickability)
	

# For playing animations
func play_anim(state: AnimState) -> void:
	if state_machine:
		print("Changing animation")
		state_machine.travel(ANIM_STRINGS[state])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_task_display()
	
	handle_mood_display()
	

func handle_task_display() -> void:
	if current_task == null:
		# Hide all barys
		for bar in task_bars:
			bar.visible = false
		return	
	
	var type = current_task.type
	var time_left = task_timer.time_left
	var time_total = task_timer.wait_time
	var percentage = (1.0 - (time_left / time_total)) * 100.0
	var active_index = type
	
	for i in range(task_bars.size()):
		if i == active_index:
			task_bars[i].visible = true
			task_bars[i].value = percentage
		else:
			task_bars[i].visible = false

func handle_mood_display() -> void:
	if current_task != null:
		for sprite in mood_sprites:
			sprite.visible = false
		return
	
	var active_index: int
	if mood > 70:
		active_index = 0
	elif mood > 30:
		active_index = 1
	else:
		active_index = 2
		
	for i in range(mood_sprites.size()):
		mood_sprites[i].visible = (i == active_index)


func _set_clickability() -> void:
	var is_clickable = RobotState.robot_is_selected and !RobotState.robot_empty
	clickable_component.is_clickable = is_clickable


func _on_click() -> void:
	Events.dragon_clicked.emit(self)


func handle_new_item(item, carrier: Robot):
	if item is Task:
		start_task(item as Task, carrier)
	if item is Prop:
		process_prop(item as Prop)


func start_task(task: Task, carrier: Robot) -> void:
	var r = randi_range(-30, 50)  # todo tweak values
	if r > mood:  # lower mood -> higher probability of eating
		# eat carrier (todo: show to player) (dragon animation added)
		play_anim(AnimState.DRAGONSBREATH)
		carrier.die()
		# Queue up next animation cause it gets stuck in this one ig..
		play_anim(AnimState.SLEEP)
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
	
	# todo: add other animations for different work types 
	play_anim(AnimState.WORK)


func _on_task_timer_timeout() -> void:
	var type = current_task.type
	var reward = reward_coefficients[type] * current_task.reward
	# todo show to player
	CurrencyManager.add_currency(reward)
	task_progression.visible = false
	current_task.queue_free()
	current_task = null
	completed_tasks += 1
	if completed_tasks == max_tasks:
		leave()
	else: 
		# Go to sleep animation cuz of animation freeze
		play_anim(AnimState.SLEEP)


func process_prop(prop: Prop):
	mood += prop.mood_boost
	mood = clamp(mood, 0, 100)
	prop.queue_free()


func leave() -> void:
	dragon_leaving.emit(self)
	if current_task:
		current_task.queue_free()
	# todo: add walking animation state for 5 seconds. With a dissapearing shader?
	queue_free()


func _on_mood_timer_timeout() -> void:
	mood -= 2
	if mood < 0:
		leave()

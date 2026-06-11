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
@export var skeleton: Skeleton3D
@export var time_coefficients: Dictionary[Task.Type, float]
@export var reward_coefficients: Dictionary[Task.Type, float]

@export_category("Walkout ANimation Settings")
## How long to turn 180 degrees
@export var turn_duration: float = 1.0 
## How long dragon walks before despawning
@export var walk_duration: float = 5.0 
## Distance moved per second in the -X direction
@export var walk_speed: float = 2.0

var is_leaving: bool = false
var current_task: Task = null
var completed_tasks: int = 0
var max_tasks: int = 3
var mood: int = 100
var dragon_meshes: Array[GeometryInstance3D] = []

@onready var task_timer: Timer = $TaskTimer
@onready var mood_timer: Timer = $MoodTimer
@onready var state_machine = anim_tree.get("parameters/playback") if anim_tree else null
@onready var task_progression: Sprite3D = $TaskProgressionFrame
@onready var task_bars: Dictionary[String, TextureProgressBar] = {
	"bad" : $TaskProgressionFrame/SubViewport/TaskType2/Task2_Fill,
	"normal" : $TaskProgressionFrame/SubViewport/TaskType1/Task1_Fill,
	"good" : $TaskProgressionFrame/SubViewport/TaskType3/Task3_Fill
}
@onready var task_bar_moods: Array[TextureRect] = [
	$TaskProgressionFrame/SubViewport/TaskMoods/Task1_Icon,
	$TaskProgressionFrame/SubViewport/TaskMoods/Task2_Icon,
	$TaskProgressionFrame/SubViewport/TaskMoods/Task3_Icon
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
	
	if skeleton:
		for child in skeleton.get_children():
			if child is MeshInstance3D:
				dragon_meshes.append(child)
	
	fade_meshes(1.0, 0.0, 2.0)


# For playing animations
func play_anim(state: AnimState) -> void:
	if state_machine:
		state_machine.travel(ANIM_STRINGS[state])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_task_display()
	
	handle_mood_display()
	

func handle_task_display() -> void:
	if current_task == null:
		# Hide all barys
		for i in task_bars:
			var bar = task_bars[i]
			bar.visible = false
		for barMoods in task_bar_moods:
			barMoods.visible = false
		return	
	
	var type = current_task.type
	var time_left = task_timer.time_left
	var time_total = task_timer.wait_time
	var percentage = (1.0 - (time_left / time_total)) * 100.0
	var active_index = type
	
	# Display correct task bar
	var coef = reward_coefficients[type]
	var task_bar: TextureProgressBar
	if coef == 1:
		task_bar = task_bars["normal"]
	elif coef > 1:
		task_bar = task_bars["good"]
	else:
		task_bar = task_bars["bad"]
	
	task_bar.visible = true
	task_bar.value = percentage
	
	# Display MoodIcon
	var current_mood: int
	if mood > 70: current_mood = 0
	elif mood > 30: current_mood = 1
	else: current_mood = 2
	
	for i in range(mood_sprites.size()):
		task_bar_moods[i].visible = (i == current_mood)

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
	
	# Play specific work animation
	match type:
		0: # TaskType 1
			play_anim(AnimState.WORK)
		1: # TaskType 2
			play_anim(AnimState.STAMPING)
		2: # TaskType 3
			play_anim(AnimState.TAKEPHONE)
		_: # Fallback
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
	if is_leaving:
		return
	is_leaving = true
	
	if not mood_timer.is_stopped(): mood_timer.stop()
	if not task_timer.is_stopped(): task_timer.stop()
	
	dragon_leaving.emit(self)
	if current_task:
		current_task.queue_free()
	
	# Rotate
	var tween = create_tween()
	tween.tween_property(self, "rotation:y", rotation.y + PI, turn_duration)
	
	# Walk out
	tween.tween_callback(func():
		play_anim(AnimState.WALK)
		
		var forward_direction = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		var target_pos = global_position
		#  + (forward_direction * walk_speed * walk_duration)
		var move_tween = create_tween()
		move_tween.tween_property(self, "global_position", target_pos, walk_duration)
		fade_meshes(0.0, 1.0, walk_duration)
	
		# Delete
		move_tween.tween_callback(queue_free)
	)


func _on_mood_timer_timeout() -> void:
	mood -= 2
	if mood < 0:
		leave()


## 0.0 is Visible
## 1.0 is Transparent
func fade_meshes(start_val: float, end_val: float, duration: float) -> void:
	if dragon_meshes.is_empty():
		return
		
	var tween = create_tween().set_parallel(true)
	
	for mesh in dragon_meshes:
		mesh.transparency = start_val
		tween.tween_property(mesh, "transparency", end_val, duration)

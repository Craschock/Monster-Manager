extends CharacterBody3D

class_name Robot

var ROTATION_SPEED: float = 4

var is_selected: bool = false

# Animations (current state)
const ANIM_IDLE = "Idle"
const ANIM_IDLE_GRAB = "Idle&Grab"
const ANIM_GRAB = "Grab"
const ANIM_DEATH = "Death"

@onready var anim_player: AnimationPlayer = $Model/AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var model: Node3D = $Model
@onready var selected_highlight: MeshInstance3D = $SelectedMesh
@onready var clickable_component: ClickableComponent = $ClickableComponent

var isAlive: bool = true
var speed: int = 5
var max_load: int = 1
# refactor - this var is useless, use carried_items.size instead
var current_load: int = 0

var target: Node3D = null
var carried_items: Array[Node3D] = []

@export var death_animation_timer: float = 10.0

func _ready() -> void:
	clickable_component.is_clickable = true
	clickable_component.on_click_callback = _on_click


func _process(_delta: float) -> void:
	for item in carried_items:
		var vec = Vector3(0.0, 1.2, 1.2).rotated(Vector3.UP, model.rotation.y)
		item.global_position = global_position + vec



func _physics_process(_delta: float) -> void:
	if not isAlive:
		remove_velocity()
		return
	else:
		var next_path_point := nav_agent.get_next_path_position()
		var new_velocity := (next_path_point - global_position).normalized() * speed
		if isAlive:
			velocity.x = new_velocity.x
			velocity.z = new_velocity.z

		# Rotation Animation for the Robot
		if velocity.length() > 0.1:
			var target_angle = atan2(velocity.x, velocity.z)
			model.rotation.y = lerp_angle(model.rotation.y, target_angle, ROTATION_SPEED * _delta)

		move_and_slide()
		update_animations()


func set_target(t: Node3D):
	target = t
	set_target_position(t.global_position)


func set_target_position(pos: Vector3):
	nav_agent.target_position = pos


func select():
	if isAlive:
		selected_highlight.visible = true


func deselect():
	selected_highlight.visible = false


func full() -> bool:
	return current_load >= max_load


func empty() -> bool:
	return current_load == 0


func add_load() -> void:
	if full():
		return
	current_load += 1
	RobotState.robot_full = full()
	RobotState.robot_empty = empty()


func remove_load() -> void:
	if empty():
		return
	current_load -= 1
	RobotState.robot_full = full()
	RobotState.robot_empty = empty()

func remove_velocity() -> void:
	velocity.x = 0.0
	velocity.z = 0.0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == target:
		target = null
		if body is Prop or body is Task:
			handle_item_reached(body)
		if body is Dragon:
			handle_dragon_reached(body as Dragon)


func handle_item_reached(item):
	remove_velocity()
	
	if !full():
		add_load()
		carried_items.push_back(item)
		Events.item_picked_up.emit(item)
		
		
		# Play grab animation
		anim_player.play(ANIM_GRAB)
		anim_player.queue(ANIM_IDLE_GRAB)

func handle_dragon_reached(dragon: Dragon):
	remove_velocity()
	
	for item in carried_items:
		dragon.handle_new_item(item, self)
		remove_load()
	carried_items.clear()

func die() -> void:
	isAlive = false
	deselect()
	for item in carried_items:
		item.queue_free()
	Events.robot_died.emit(self)
	
	# Play death animation
	anim_player.play(ANIM_DEATH)
	await anim_player.animation_finished # To wait until animation finishes
	
	# Shrink model and then delete after timer finishes
	var tween = create_tween()
	tween.tween_property(model, "scale", Vector3.ZERO, death_animation_timer)
	tween.tween_callback(queue_free)

# For animation 
func update_animations() -> void:
	if !isAlive:
		return
	# Check so it won't interrupt death or grab animation
	if anim_player.current_animation == ANIM_DEATH or anim_player.current_animation == ANIM_GRAB:
		return
		
	# Play other animations otherwise 
	if carried_items.size() > 0:
		anim_player.play(ANIM_IDLE_GRAB)
	else:
		anim_player.play(ANIM_IDLE)


func _on_click() -> void:
	Events.robot_clicked.emit(self)

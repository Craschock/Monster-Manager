extends RigidBody3D

class_name Task

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var clickable_component: ClickableComponent = $ClickableComponent

enum Type {TYPE1, TYPE2, TYPE3}

@export var time_to_complete: int
@export var reward: int
@export var type: Type


func _ready() -> void:
	_set_clickable()
	clickable_component.on_click_callback = _on_click
	RobotState.robot_state_changed.connect(_set_clickable)


func _on_click() -> void:
	Events.task_clicked.emit(self)


func _set_clickable() -> void:
	var is_clickable = RobotState.robot_is_selected and !RobotState.robot_full
	clickable_component.is_clickable = is_clickable

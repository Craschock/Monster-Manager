extends RigidBody3D

class_name Prop

var spawner: PropSpawner
@export var mood_boost: int

@onready var clickable_component: ClickableComponent = $ClickableComponent

func _ready() -> void:
	_set_clickable()
	clickable_component.on_click_callback = _on_click
	RobotState.robot_state_changed.connect(_set_clickable)


func _on_click() -> void:
	Events.prop_clicked.emit(self)


func _set_clickable() -> void:
	var is_clickable = RobotState.robot_is_selected and !RobotState.robot_full
	clickable_component.is_clickable = is_clickable

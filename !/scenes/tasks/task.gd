extends RigidBody3D

class_name Task

@onready var mesh: MeshInstance3D = $MeshInstance3D

enum Type {TYPE1, TYPE2, TYPE3}

var time_to_complete: int
var reward: int
var type: Type


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("Task clicked")
			Events.task_clicked.emit(self)

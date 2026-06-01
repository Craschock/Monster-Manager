extends RigidBody3D

class_name Prop

var spawner: PropSpawner
var mood_boost: int

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Events.prop_clicked.emit(self)

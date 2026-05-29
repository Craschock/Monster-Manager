extends RigidBody3D

class_name Task

@onready var mesh: MeshInstance3D = $MeshInstance3D

var carrier: Robot = null

# alternatively use separate types (classes) for individual tasks
# now they differ only in values, but if they diffen in model, it could be a different class maybe?
enum Type {TYPE1, TYPE2, TYPE3}

var time_to_complete: int
var reward: int
var type: Type


func _physics_process(delta: float) -> void:
	if carrier:
		var pos = carrier.position + Vector3(0.0, 3.0, 0.0)
		position = pos


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("Task clicked")
			Events.task_clicked.emit(self)

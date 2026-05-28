extends Node3D

class_name Task

@onready var mesh: MeshInstance3D = $MeshInstance3D

# alternatively use separate types (classes) for individual tasks
# now they differ only in values, but if they diffen in model, it could be a different class maybe?
enum Type {TYPE1, TYPE2, TYPE3}

var time_to_complete: int
var reward: int
var type: Type

func initialize(ttc: int, rew: int, t: Type) -> void:
	time_to_complete = ttc
	reward = rew
	type = t
	
func set_color(color: Color) -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Events.task_clicked.emit(self)

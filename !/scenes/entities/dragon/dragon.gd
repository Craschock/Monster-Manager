extends Node3D

class_name Dragon

signal dragon_clicked(dragon: Dragon)
signal dragon_leaving(dragon: Dragon)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_model_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("Dragon clicked")
			dragon_clicked.emit(self)
			#leave()


func leave() -> void:
	dragon_leaving.emit(self)
	queue_free()

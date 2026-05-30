extends Node3D

class_name Dragon

signal dragon_leaving(dragon: Dragon)

var current_task: Task = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_model_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Events.dragon_clicked.emit(self)
			#leave()


func leave() -> void:
	dragon_leaving.emit(self)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Task:
		var task = body as Task
		var carrier = task.carrier
		task.carrier = null
		carrier.remove_load()
		current_task = task
		# todo start working on task

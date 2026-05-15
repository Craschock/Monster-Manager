extends StaticBody3D

class_name Dragon

signal dragon_clicked(dragon: Dragon)

var is_red: bool = true

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			dragon_clicked.emit(self)
			

func toggle_color():
	var red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED
	var blue_material = StandardMaterial3D.new()
	blue_material.albedo_color = Color.BLUE
	
	if is_red:
		$MeshInstance3D.material_override = blue_material
		is_red = false
	else:
		$MeshInstance3D.material_override = red_material
		is_red = true
	

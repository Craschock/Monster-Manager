extends Node

class_name ClickableComponent

@export var collision_object: CollisionObject3D
# all nodes in outline group must have the visible property
@export var outline_group: String = "outline"
var outline: Array[Node]

# interface - these two properties should be modified from outside
var is_clickable: bool = true
var on_click_callback: Callable

func _ready() -> void:
	collision_object.mouse_entered.connect(_on_mouse_entered)
	collision_object.mouse_exited.connect(_on_mouse_exited)
	collision_object.input_event.connect(_on_input_event)
	for node in get_tree().get_nodes_in_group(outline_group):
		if node.owner == owner:
			outline.append(node)


func _enable_outline() -> void:
	for node in outline:
		node.visible = true


func _disable_outline() -> void:
	for node in outline:
		node.visible = false


func _on_mouse_entered():
	if is_clickable:
		_enable_outline()


func _on_mouse_exited():
	_disable_outline()


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and is_clickable:
			on_click_callback.call()

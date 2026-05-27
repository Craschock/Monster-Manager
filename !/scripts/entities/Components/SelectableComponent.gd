extends Node
class_name SelectableComponent

@export_category("Visuals")
## assign mesh or decal here later to show selection
@export var selection_ring: Node3D 

var is_selected: bool = false

func select() -> void:
	is_selected = true
	if selection_ring:
		selection_ring.visible = true

func deselect() -> void:
	is_selected = false
	if selection_ring:
		selection_ring.visible = false

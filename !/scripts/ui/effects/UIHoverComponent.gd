extends Node
class_name UIHoverComponent

@export_category("Hover Animation Settings")
@export var tilt_angle_degrees: float = 5.0
@export var animation_duration: float = 0.1
@export var outline_thickness: int = 64
@export var outline_color: Color = Color.BLACK

@export_category("Layout Fixes")
## Temporary Fix. Check this ONLY for buttons inside Visual Containers (like VBoxContainer etc.)
@export var auto_center_pivot: bool = false

var parent_btn: Button
var hover_tween: Tween
var original_rotation_degrees: float = 0.0

func _ready() -> void:
	await get_tree().process_frame
	
	# Grab parent node and check if button
	var parent = get_parent()
	if parent is Button:
		parent_btn = parent
		
		# parent_btn.pivot_offset = parent_btn.size / 2.0
		# Line above is bugged. PLEASE add pivot manually. Here's how to:
		# Go to the button, layout, transform
		# under "size" and "pivot offset", write the following
		# Pivot Offset X = (half of Size_X)
		# Pivot Offset Y = (half of Size_Y)
		# Done
		
		# The temp fix for containers is this:
		if auto_center_pivot:
			parent_btn.pivot_offset = parent_btn.size / 2.0
		
		
		
		original_rotation_degrees = parent_btn.rotation_degrees
		
		# Set outline color override
		parent_btn.add_theme_color_override("font_outline_color", outline_color)
		
		# Listen for mouse signals
		parent_btn.mouse_entered.connect(_on_mouse_entered)
		parent_btn.mouse_exited.connect(_on_mouse_exited)
	else:
		push_warning("UIHoverComponent must be a child of a Button node!")

# Animations/Effects to text on hover
func _on_mouse_entered() -> void:
	# Kill other running animations
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
		
	hover_tween = create_tween()
	# Tilt button
	hover_tween.tween_property(parent_btn, "rotation_degrees", tilt_angle_degrees, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Apply text outline
	parent_btn.add_theme_constant_override("outline_size", outline_thickness)

# Animation/Reset button on exit
func _on_mouse_exited() -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	hover_tween = create_tween()
	# Rotate button back
	hover_tween.tween_property(parent_btn, "rotation_degrees", original_rotation_degrees, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	# Remove outline thickness
	parent_btn.add_theme_constant_override("outline_size", 0)

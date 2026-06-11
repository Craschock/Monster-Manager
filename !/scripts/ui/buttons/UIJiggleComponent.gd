extends Label
class_name UIJiggleComponent

@export_category("Jiggle Settings")
## How far the label tilts in degrees
@export var tilt_angle: float = 15.0
## How fast each jiggle motion takes
@export var jiggle_speed: float = 0.08 

@export_category("Color Settings")
## Color when gaining currency
@export var positive_color: Color = Color.GREEN
## Color when losing currency
@export var negative_color: Color = Color.RED
## Color to return to after the jiggle
@export var default_color: Color = Color.WHITE

var active_tween: Tween

func _ready() -> void:
	# Ensure pivot is in center so it rotates correctly
	pivot_offset = size / 2.0
	
	# Set the default color on startup
	add_theme_color_override("font_color", default_color)

# --- NEW: Added is_positive parameter ---
func play_jiggle(is_positive: bool = true) -> void:
	if active_tween and active_tween.is_valid():
		active_tween.kill()
		
	active_tween = create_tween()
	
	# Determine which color to flash!
	var flash_color = positive_color if is_positive else negative_color
	add_theme_color_override("font_color", flash_color)
	
	# Tilt Left
	active_tween.tween_property(self, "rotation_degrees", -tilt_angle, jiggle_speed).set_trans(Tween.TRANS_SINE)
	
	# Tilt Right
	active_tween.tween_property(self, "rotation_degrees", tilt_angle, jiggle_speed * 2.0).set_trans(Tween.TRANS_SINE)
	
	# Snap back
	active_tween.tween_property(self, "rotation_degrees", 0.0, jiggle_speed).set_trans(Tween.TRANS_SINE)
	
	# Revert color
	active_tween.tween_callback(func(): add_theme_color_override("font_color", default_color))

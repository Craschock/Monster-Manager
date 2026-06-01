extends CanvasLayer
class_name MainHUD


# Exüporting stuff for testing purposes
@export_category("UI Panels")
@export var robot_shop_panel: AnimatedPanel
@export var prop_shop_panel: AnimatedPanel

@export_category("Navigation Buttons")
@export var btn_robot_shop: Button
@export var btn_prop_shop: Button

# What is currently open
var current_open_panel: Control = null

func _ready() -> void:
	# Connect buttons
	if btn_robot_shop:
		btn_robot_shop.pressed.connect(func(): toggle_panel(robot_shop_panel))
	if btn_prop_shop:
		btn_prop_shop.pressed.connect(func(): toggle_panel(prop_shop_panel))

func toggle_panel(panel_to_toggle: Control) -> void:
	# If clicking the button for the panel that is already open, just close it
	if current_open_panel == panel_to_toggle:
		panel_to_toggle.close_panel()
		current_open_panel = null
		return
		
	# If another panel is open, hide it first
	if current_open_panel != null:
		current_open_panel.close_panel()
		
	# Open the requested panel
	panel_to_toggle.open_panel()
	current_open_panel = panel_to_toggle

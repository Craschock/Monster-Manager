extends CanvasLayer

@onready var robot_shop_panel: AnimatedPanel = $RobotShopPanel
@onready var prop_shop_panel: AnimatedPanel = $PropShopPanel

# What is currently open
var current_open_panel: Control = null

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


func _on_b_open_robot_shop_pressed() -> void:
	toggle_panel(robot_shop_panel)


func _on_b_open_prop_shop_pressed() -> void:
	toggle_panel(prop_shop_panel)

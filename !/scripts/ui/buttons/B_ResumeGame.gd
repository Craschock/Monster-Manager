extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	var pause_menu_root = owner 
	if pause_menu_root.has_method("close_animation"):
		pause_menu_root.close_animation()

extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	# Closes entire application
	get_tree().quit()

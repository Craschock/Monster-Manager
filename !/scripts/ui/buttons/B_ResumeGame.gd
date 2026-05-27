extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	# Tell UIManager to flip pause state and destroy menu
	UIManager.toggle_pause()

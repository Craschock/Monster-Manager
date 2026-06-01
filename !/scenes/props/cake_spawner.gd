extends PropSpawner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	prop_scn = preload("res://!/scenes/prefabs/cake.tscn")
	Events.cake_bought.connect(enable)

extends PropSpawner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	prop_scn = preload("res://!/scenes/props/water.tscn")
	Events.water_bought.connect(enable)

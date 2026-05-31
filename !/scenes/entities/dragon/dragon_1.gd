extends Dragon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_coefficients = {
		Task.Type.TYPE1 : 0.5,
		Task.Type.TYPE2 : 0.5,
		Task.Type.TYPE3 : 1.0,
	}
	reward_coefficients = {
		Task.Type.TYPE1 : 2.0,
		Task.Type.TYPE2 : 0.5,
		Task.Type.TYPE3 : 1.0,
	}

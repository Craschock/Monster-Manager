extends ShopItem


func _init() -> void:
	price = 500
	sig = Events.robot_bought
	is_prop = false

extends ShopItem


func _init() -> void:
	price = 100
	sig = Events.speed_increase_bought
	is_prop = false

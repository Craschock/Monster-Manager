extends ShopItem


func _init() -> void:
	price = 300
	sig = Events.water_bought
	is_prop = true

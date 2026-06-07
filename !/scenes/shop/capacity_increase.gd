extends ShopItem


func _init() -> void:
	price = 300
	sig = Events.capacity_increase_bought
	is_prop = false

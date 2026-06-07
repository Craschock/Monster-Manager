extends ShopItem


func _init() -> void:
	price = 600
	sig = Events.cake_bought
	is_prop = true

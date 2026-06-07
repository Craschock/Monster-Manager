extends ShopItem


func _init() -> void:
	price = 400
	sig = Events.coffe_bought
	is_prop = true

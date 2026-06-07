extends Node

class_name Shop

@onready var buy_robot_button: BaseButton = $ShopUI/RobotShopPanel/VBoxContainer/B_BuyRobot
@onready var speed_increase_button: BaseButton = $ShopUI/RobotShopPanel/VBoxContainer/B_SpeedIncrease
@onready var capacity_increase_button: BaseButton = $ShopUI/RobotShopPanel/VBoxContainer/B_CapacityIncrease
@onready var buy_coffe_button: BaseButton = $ShopUI/PropShopPanel/VBoxContainer/B_Coffe
@onready var buy_cake_button: BaseButton = $ShopUI/PropShopPanel/VBoxContainer/B_Cake

const BuyRobotSnc: PackedScene = preload("res://!/scenes/shop/buy_robot.tscn")
const SpeedIncreaseScn: PackedScene = preload("res://!/scenes/shop/speed_increase.tscn")
const CapacityIncreaseScn: PackedScene = preload("res://!/scenes/shop/capacity_increase.tscn")
const CoffeScn: PackedScene = preload("res://!/scenes/shop/coffe.tscn")
const CakeScn: PackedScene = preload("res://!/scenes/shop/cake.tscn")

var button_to_item: Dictionary[BaseButton, ShopItem]

func _ready() -> void:
	button_to_item = {
		buy_robot_button : BuyRobotSnc.instantiate(),
		speed_increase_button : SpeedIncreaseScn.instantiate(),
		capacity_increase_button : CapacityIncreaseScn.instantiate(),
		buy_coffe_button : CoffeScn.instantiate(),
		buy_cake_button : CakeScn.instantiate()
	}
	Events.currency_changed.connect(_on_currency_changed)
	# bcs currency manager loads before this ready function is called
	# not a clean solution tho :(
	_on_currency_changed(CurrencyManager.STARTING_BALANCE)
	update_button_texts()
	

# only temporary solution?
func update_button_texts() -> void:
	for button in button_to_item:
		var price = button_to_item[button].price
		button.text += " (%s)" % price


func _on_shop_button_pressed(button: BaseButton) -> void:
	var item = button_to_item[button]
	var price = item.price
	if CurrencyManager.spend_currency(price):
		item.sig.emit()
		item.is_bought = true


func _on_currency_changed(new_currency: int) -> void:
	for button in button_to_item:
		var item = button_to_item[button]
		if new_currency < item.price:
			button.disabled = true
		elif item.is_prop and item.is_bought:
			button.disabled = true
		else:
			button.disabled = false
		
		

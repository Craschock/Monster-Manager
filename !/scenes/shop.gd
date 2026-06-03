extends Node

class_name Shop

@onready var buy_robot_button: BaseButton = $ShopUI/RobotShopPanel/VBoxContainer/B_BuyRobot
@onready var speed_increase_button: BaseButton = $ShopUI/RobotShopPanel/VBoxContainer/B_SpeedIncrease
@onready var capacity_increase_button: BaseButton = $ShopUI/RobotShopPanel/VBoxContainer/B_CapacityIncrease

@onready var buy_coffe_button: BaseButton = $ShopUI/PropShopPanel/VBoxContainer/B_Coffe
@onready var buy_cake_button: BaseButton = $ShopUI/PropShopPanel/VBoxContainer/B_Cake

var buttons: Array[Button]
var button_to_price: Dictionary[BaseButton, int]
var button_to_signal: Dictionary[BaseButton, Signal]

func _ready() -> void:
	buttons = [
		buy_robot_button,
		speed_increase_button,
		capacity_increase_button,
		
		buy_coffe_button,
		buy_cake_button,
	]
	button_to_price = {
		buy_robot_button : 500,
		speed_increase_button : 100,
		capacity_increase_button : 200,
		
		buy_coffe_button : 300,
		buy_cake_button : 600,
	}
	button_to_signal = {
		buy_robot_button : Events.robot_bought,
		speed_increase_button : Events.speed_increase_bought,
		capacity_increase_button : Events.capacity_increase_bought,
		
		buy_coffe_button : Events.coffe_bought,
		buy_cake_button : Events.cake_bought,
	}
	Events.currency_changed.connect(_on_currency_changed)
	update_button_texts()


# only temporary solution?
func update_button_texts() -> void:
	for button in buttons:
		var price = button_to_price[button]
		button.text += " (%s)" % price


func _on_shop_button_pressed(button: BaseButton) -> void:
	var price = button_to_price[button]
	if CurrencyManager.spend_currency(price):
		var sig = button_to_signal[button]
		sig.emit()


func _on_currency_changed(new_currency: int) -> void:
	for button in buttons:
		var price = button_to_price[button]
		button.disabled = price > new_currency

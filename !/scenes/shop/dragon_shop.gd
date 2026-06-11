extends Control

const PRICE = 400

var selected_spawner: SpawnPoint

@onready var buy_dragon_button: Button = $B_BuyDragon

func _ready() -> void:
	Events.dragon_spawner_clicked.connect(_on_dragon_spawner_clicked)
	Events.currency_changed.connect(_on_currency_changed)


func _on_dragon_spawner_clicked(spawner: SpawnPoint) -> void:
	visible = true
	selected_spawner = spawner


func _on_b_cancle_dragon_pressed() -> void:
	visible = false
	selected_spawner = null


func _on_b_buy_dragon_pressed() -> void:
	if CurrencyManager.spend_currency(PRICE):
		selected_spawner.bought()
		Events.dragon_spawner_bought.emit(selected_spawner)
		selected_spawner = null
		visible = false

func _on_currency_changed(new_currency: int) -> void:
	buy_dragon_button.disabled = new_currency < PRICE

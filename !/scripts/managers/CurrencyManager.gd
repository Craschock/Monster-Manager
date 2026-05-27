extends Node

# Signal to UI elements when money changes TODO
signal currency_changed(new_amount: int)

const STARTING_BALANCE: int = 500
const MIN_BALANCE: int = 0

@export_category("Economy Balance")
@export var current_currency: int = STARTING_BALANCE

func _ready() -> void:
	# Broadcast initial balance on startup
	currency_changed.emit(current_currency)

# Function for everyone to add currency to player
func add_currency(amount: int) -> void:
	if amount <= 0:
		return
		
	current_currency += amount
	currency_changed.emit(current_currency)

# Function for everyone to spend currency
# Returns true if purchase was successful, false if too broke
func spend_currency(amount: int) -> bool:
	if amount <= 0:
		return false
		
	if current_currency >= amount:
		current_currency -= amount
		currency_changed.emit(current_currency)
		return true
		
	# purchase failed (not enough currency)
	return false

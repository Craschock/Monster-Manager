extends CanvasLayer

class_name MainHUD

@onready var currency_label: Label = $L_CurrentCurrency

func _ready() -> void:
	print("connecting")
	Events.currency_changed.connect(_on_currency_changed)
	# bcs currency manager loads before this ready function is called
	# not a clean solution tho :(
	_on_currency_changed(CurrencyManager.STARTING_BALANCE)


func _on_b_camera_rotate_left_pressed() -> void:
	Input.action_press("rotate_anticlockwise")
	Input.action_release("rotate_anticlockwise")


func _on_b_camera_rotate_right_pressed() -> void:
	Input.action_press("rotate_clockwise")
	Input.action_release("rotate_clockwise")


func _on_currency_changed(new_currency: int) -> void:
	currency_label.text = str(new_currency)


# todo remove, only for testing purposes
func _on_add_money_pressed() -> void:
	CurrencyManager.add_currency(100)

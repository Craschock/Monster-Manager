extends CanvasLayer

class_name MainHUD

@onready var currency_label: Label = $L_CurrentCurrency
@onready var time_label: Label = $L_Time

func _ready() -> void:
	print("connecting")
	Events.currency_changed.connect(_on_currency_changed)
	# bcs currency manager loads before this ready function is called
	# not a clean solution tho :(
	_on_currency_changed(CurrencyManager.STARTING_BALANCE)
	Events.time_changed.connect(_on_time_changed)
	
	# for enable/disable UI:
	Events.game_paused.connect(_on_game_paused)

func _on_game_paused(is_paused: bool) -> void:
	# If paused is true, visible becomes false. 
	# If paused is false, visible becomes true.
	visible = not is_paused

func _on_b_camera_rotate_left_pressed() -> void:
	Input.action_press("rotate_anticlockwise")
	Input.action_release("rotate_anticlockwise")


func _on_b_camera_rotate_right_pressed() -> void:
	Input.action_press("rotate_clockwise")
	Input.action_release("rotate_clockwise")


func _on_currency_changed(new_currency: int) -> void:
	var old_currency: int = 0
	if currency_label.text.is_valid_int():
		old_currency = int(currency_label.text)
	currency_label.text = str(new_currency)
	
	if currency_label.has_method("play_jiggle"):
		currency_label.play_jiggle(new_currency >= old_currency)


func _on_time_changed(new_time: int) -> void:
	var min: int = new_time / 60
	var sec: int = new_time % 60
	time_label.text = "{0}:{1}".format([min, sec])


# todo remove, only for testing purposes
func _on_add_money_pressed() -> void:
	CurrencyManager.add_currency(100)

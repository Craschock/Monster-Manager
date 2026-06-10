extends Node

@onready var end_of_game_ui = $EndOfGameUI
@onready var money_label = $EndOfGameUI/MoneyLabel

var time: int = 300

func _on_timer_timeout() -> void:
	time -= 1
	Events.time_changed.emit(time)
	if time == 0:
		var money = CurrencyManager.current_currency
		money_label.text = "Final money: $" + str(money)
		end_of_game_ui.visible = true
		get_tree().paused = true

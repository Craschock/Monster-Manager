extends Node
class_name PlayerStats

# Variables and constants
const MAX_SCORE: int = 999999
const MAX_TIME: float = 3600.0 # 1 hour max shift time

@export_category("General Stats")
## Tracker for current Score
@export var current_score: int = 0
## Tiomer for game-end
@export var elapsed_time: float = 0.0

@export_category("Upgrades")
# Stuff like unlocks and upgrades
# currently some random stuff. 
# dunno what the best way to implement the upgrades is
# maybe into each robot?

# Unlocks:
# e.g. @export var coffee_machine_unlocked: bool = false
# @export var vending_machine_unlocked: bool = false


# Upgrades
# @export var dragon_currency_multiplier: int = 1
# @export var bot_move_speed_multiplier: float = 1.0
# @export var bot_work_multiplier: float = 1.0
# @export var max_bot_capacity: int = 5


@export_category("Economy Tracking")
# Tracking for Challenge mode

# @export var total_currency_earned: int = 0
# @export var total_currency_spent: int = 0
# @export var lifetime_dragons_fed: int = 0
# @export var total_bots_destroyed: int = 0
# @export var total_bots_bought: int = 0
# and other stuff ig

func _process(delta: float) -> void:
	if elapsed_time < MAX_TIME:
		elapsed_time += delta

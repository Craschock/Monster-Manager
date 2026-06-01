extends Node

class_name Shop

var UI: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI = $UI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_shop"):
		toggle_ui()
	
func toggle_ui() -> void:
	UI.visible = !UI.visible


func _on_buy_robot_pressed() -> void:
	# todo currency check
	# if enough money
	#	emit bought
	# else
	#	show not enough money message
	Events.robot_bought.emit()
	


func _on_speed_increase_pressed() -> void:
	# todo currency check
	Events.speed_increase_bought.emit()


func _on_capacity_increase_pressed() -> void:
	# todo currency check
	Events.capacity_increase_bought.emit()


func _on_cake_pressed() -> void:
	# todo currency check
	Events.cake_bought.emit()


func _on_coffee_pressed() -> void:
	# todo currency check
	Events.coffe_bought.emit()

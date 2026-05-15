extends Node

#var robots: Array[Robot]
var selected_robot: Robot = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		var robot = child as Robot
		#robots.append(robot)
		robot.robot_clicked.connect(_on_robot_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_robot_clicked(clicked_robot: Robot):
	if selected_robot:
		selected_robot.deselect()
		if selected_robot == clicked_robot:
			selected_robot = null
		else:
			clicked_robot.select()
			selected_robot = clicked_robot
	else:
		clicked_robot.select()
		selected_robot = clicked_robot


func _on_dragon_manager_dragon_clicked(dragon: Dragon) -> void:
	if selected_robot:
		selected_robot.set_target_position(dragon.global_position)

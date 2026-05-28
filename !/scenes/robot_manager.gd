extends Node

class_name RobotManager

@onready var spawn_point: Marker3D = $SpawnPoint

const RobotScn = preload("res://!/scenes/entities/robot/robot.tscn")

var selected_robot: Robot = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.robot_bought.connect(create_new_robot)
	Events.speed_increase_bought.connect(increase_speed)
	
	Events.robot_clicked.connect(on_robot_clicked)
	Events.dragon_clicked.connect(on_dragon_clicked)
	Events.task_clicked.connect(on_task_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_new_robot() -> void:
	print("creating new robot")
	var robot: Robot = RobotScn.instantiate()
	robot.position = spawn_point.position
	add_child(robot)


func increase_speed() -> void:
	print("increasing speed")


func on_robot_clicked(clicked_robot: Robot) -> void:
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


func on_dragon_clicked(dragon: Dragon) -> void:
	if selected_robot:
		selected_robot.set_target_position(dragon.position)

func on_task_clicked(task: Task) -> void:
	if selected_robot:
		selected_robot.set_target_position(task.position)

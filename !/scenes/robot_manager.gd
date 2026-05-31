extends Node

class_name RobotManager

@onready var spawn_point: Marker3D = $SpawnPoint

const RobotScn = preload("res://!/scenes/entities/robot/robot.tscn")

var robots: Array[Robot] = []

var selected_robot: Robot = null

var robots_speed: int = 5
var robots_capacity: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.robot_bought.connect(create_new_robot)
	Events.speed_increase_bought.connect(increase_speed)
	Events.capacity_increase_bought.connect(increase_capacity)
	
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
	robot.speed = robots_speed
	robot.max_load = robots_capacity
	add_child(robot)
	robots.append(robot)
	


func increase_speed() -> void:
	robots_speed += 5
	for robot in robots:
		robot.speed = robots_speed


func increase_capacity() -> void:
	robots_capacity += 1
	for robot in robots:
		robot.max_load = robots_capacity

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

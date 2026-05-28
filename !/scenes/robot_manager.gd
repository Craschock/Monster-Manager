extends Node

class_name RobotManager

@onready var spawn_point: Marker3D = $SpawnPoint

const RobotScn = preload("res://!/scenes/entities/robot/robot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.robot_bought.connect(create_new_robot)
	Events.speed_increase_bought.connect(increase_speed)


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

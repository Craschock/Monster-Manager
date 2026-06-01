extends Node

@warning_ignore_start("unused_signal")
signal robot_bought
signal speed_increase_bought
signal capacity_increase_bought

signal coffe_bought
signal cake_bought

signal robot_clicked(robot: Robot)

# todo merge into single signal?
signal dragon_clicked(dragon: Dragon)
signal task_clicked(task: Task)
signal prop_clicked(prop: Prop)

signal item_picked_up(item)

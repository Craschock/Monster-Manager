extends Node3D

class_name Task

# alternatively use separate types (classes) for individual tasks
# now they differ only in values, but if they diffen in model, it could be a different class maybe?
enum Type {TYPE1, TYPE2, TYPE3}

var time_to_complete: int
var reward: int
var type: Type

func _init(time_to_complete: int, reward: int, type: Type) -> void:
	self.time_to_complete = time_to_complete
	self.reward = reward
	self.type = type

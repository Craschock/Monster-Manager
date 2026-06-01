extends Node3D

class_name PropSpawner

var prop_scn: PackedScene

@onready var timer: Timer = $Timer
@onready var marker: Marker3D = $Marker3D

var count: int = 0
const CAPACITY: int = 3
const WAIT_TIME: int = 2

func _ready() -> void:
	visible = false
	Events.item_picked_up.connect(on_item_picked_up)


func enable() -> void:
	visible = true
	timer.start(WAIT_TIME)


func _on_timer_timeout() -> void:
	if count < CAPACITY:
		var prop: Prop = prop_scn.instantiate()
		prop.position = marker.position
		prop.spawner = self
		add_child(prop)
		count += 1


func on_item_picked_up(item):
	if item is Prop:
		var prop = item as Prop
		if prop.spawner == self:
			count -= 1

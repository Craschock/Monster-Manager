extends Node

const MIN_WAIT_TIME = 3
const MAX_WAIT_TIME = 6
const DragonScn: PackedScene = preload("res://!/scenes/entities/dragon/dragon.tscn")

@onready var new_dragon_timer: Timer = $NewDragonTimer
var free_spawn_points: Array[SpawnPoint]
var occupied_spawn_points: Dictionary[Dragon, SpawnPoint]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is SpawnPoint:
			free_spawn_points.append(child)

	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_timer() -> void:
	new_dragon_timer.start(randi_range(MIN_WAIT_TIME, MAX_WAIT_TIME))


func _on_new_dragon_timer_timeout() -> void:
	if !free_spawn_points.is_empty():
		var spawn_point: SpawnPoint = free_spawn_points.pick_random()
		var dragon: Dragon = DragonScn.instantiate()
		dragon.position = spawn_point.position
		dragon.dragon_leaving.connect(_on_dragon_leaving)
		add_child(dragon)
		
		free_spawn_points.erase(spawn_point)
		occupied_spawn_points[dragon] = spawn_point
	else:
		pass
		
	start_timer()


func _on_dragon_leaving(dragon: Dragon) -> void:
	var spawn_point = occupied_spawn_points[dragon]
	occupied_spawn_points.erase(dragon)
	free_spawn_points.append(spawn_point)

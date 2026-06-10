extends Node

const MIN_WAIT_TIME = 3
const MAX_WAIT_TIME = 6

# Small Dragons
const Dragon_s_1Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_small/dragon_s_01.tscn")
const Dragon_s_2Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_small/dragon_s_02.tscn")
const Dragon_s_3Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_small/dragon_s_03.tscn")
const Dragon_s_4Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_small/dragon_s_04.tscn")
const Dragon_s_5Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_small/dragon_s_05.tscn")
const Dragon_s_6Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_small/dragon_s_06.tscn")
const DRAGON_S_SCNS: Array[PackedScene] = [
	Dragon_s_1Scn,
	Dragon_s_2Scn,
	Dragon_s_3Scn,
	Dragon_s_4Scn,
	Dragon_s_5Scn,
	Dragon_s_6Scn
]

# Large Dragons
const Dragon_l_1Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_large/dragon_l_01.tscn")
const Dragon_l_2Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_large/dragon_l_02.tscn")
const Dragon_l_3Scn: PackedScene = preload("res://!/scenes/entities/dragon/dragon_large/dragon_l_03.tscn")
const DRAGON_L_SCNS: Array[PackedScene] = [
	Dragon_l_1Scn,
	Dragon_l_2Scn,
	Dragon_l_3Scn
]
# todo: add stuff for large dragon

## Add the parent node for Small Dragon Spawnpoints
@export var Spawnpoints_S: Node3D
## Add the parent node for Large Dragon Spawnpoints
@export var Spawnpoints_L: Node3D

@onready var new_dragon_timer: Timer = $NewDragonTimer
var free_spawn_points_S: Array[SpawnPoint]
var free_spawn_points_L: Array[SpawnPoint]
var occupied_spawn_points: Dictionary[Dragon, SpawnPoint]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Small Dragons
	for child in Spawnpoints_S.get_children():
		if child is SpawnPoint:
			free_spawn_points_S.append(child)
	# Large Dragons
	for child in Spawnpoints_L.get_children():
		if child is SpawnPoint:
			free_spawn_points_L.append(child)

	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_timer() -> void:
	new_dragon_timer.start(randi_range(MIN_WAIT_TIME, MAX_WAIT_TIME))


func _on_new_dragon_timer_timeout() -> void:
	if !free_spawn_points_S.is_empty():
		var spawn_point: SpawnPoint = free_spawn_points_S.pick_random()
		#var dragon: Dragon = DragonScn.instantiate()
		# todo pick random
		# todo tweak coefficients
		var dragon_s_scn = DRAGON_S_SCNS.pick_random()
		var dragon: Dragon = dragon_s_scn.instantiate()
		dragon.position = spawn_point.position
		dragon.rotation.y = spawn_point.get_facing_angle() # Apply rotation from facing direction
		dragon.dragon_leaving.connect(_on_dragon_leaving)
		add_child(dragon)
		
		free_spawn_points_S.erase(spawn_point)
		occupied_spawn_points[dragon] = spawn_point
	else:
		pass
	
	if !free_spawn_points_L.is_empty():
		var spawn_point: SpawnPoint = free_spawn_points_L.pick_random()
		#var dragon: Dragon = DragonScn.instantiate()
		# todo pick random
		# todo tweak coefficients
		var dragon_l_scn = DRAGON_L_SCNS.pick_random()
		var dragon: Dragon = dragon_l_scn.instantiate()
		dragon.position = spawn_point.position
		dragon.rotation.y = spawn_point.get_facing_angle() # Apply rotation from facing direction
		dragon.dragon_leaving.connect(_on_dragon_leaving)
		add_child(dragon)
		
		free_spawn_points_L.erase(spawn_point)
		occupied_spawn_points[dragon] = spawn_point
	else:
		pass
	
	start_timer()


func _on_dragon_leaving(dragon: Dragon) -> void:
	var spawn_point = occupied_spawn_points[dragon]
	occupied_spawn_points.erase(dragon)
	
	if spawn_point.get_parent() == Spawnpoints_S:
		free_spawn_points_S.append(spawn_point)
	elif spawn_point.get_parent() == Spawnpoints_L:
		free_spawn_points_L.append(spawn_point)
	else:
		push_warning("Parent not found in S or L categories.")

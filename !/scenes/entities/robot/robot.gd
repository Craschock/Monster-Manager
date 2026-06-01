extends CharacterBody3D

class_name Robot

var is_selected: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

var speed: int = 5
var max_load: int = 1
# refactor - this var is useless, use carried_items.size instead
var current_load: int = 0

var target: Node3D = null
var carried_items: Array[Node3D] = []


func _process(_delta: float) -> void:
	for item in carried_items:
		item.global_position = global_position + Vector3(0.0, 3.0, 0.0)


func _physics_process(_delta: float) -> void:
	var next_path_point := nav_agent.get_next_path_position()
	var new_velocity := (next_path_point - global_position).normalized() * speed
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z

	move_and_slide()


func set_target(t: Node3D):
	target = t
	set_target_position(t.global_position)


func set_target_position(pos: Vector3):
	print("navigating to %s..." % pos)
	nav_agent.target_position = pos


func select():
	var color = Color.DARK_BLUE
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat


func deselect():
	var color = Color.SKY_BLUE
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat


# todo refactor
func add_load() -> void:
	if current_load < max_load:
		current_load += 1


func remove_load() -> void:
	if current_load > 0:
		current_load -= 1


func full() -> bool:
	return current_load >= max_load


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("Robot sclicked")
			Events.robot_clicked.emit(self)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == target:
		target = null
		if body is Prop or body is Task:
			handle_item_reached(body)
		if body is Dragon:
			handle_dragon_reached(body as Dragon)

func handle_item_reached(item):
	if !full():
		add_load()
		carried_items.push_back(item)
		Events.item_picked_up.emit(item)


func handle_dragon_reached(dragon: Dragon):
	for item in carried_items:
		dragon.handle_new_item(item, self)
		remove_load()
	carried_items.clear()


func die() -> void:
	for item in carried_items:
		item.queue_free()
	Events.robot_died.emit(self)
	queue_free()

extends CanvasLayer

@export_category("tear Settings")
## How many zigzags in the tear
@export var jagged_points: int = 15
## Minimum distance the cut travels horizontally
@export var min_depth: float = 15.0
## Maximum distance the cut travels horizontally
@export var max_depth: float = 45.0 
## Randomizer Strength of length of each cut
@export var vertical_variance: float = 15.0 
## Overall Distance between the two parts
@export var rip_distance: float = 150.0


@onready var left_poly: Polygon2D = $LeftHalf
@onready var right_poly: Polygon2D = $RightHalf
@onready var ui_container: VBoxContainer = $VBoxContainer
@onready var dim_background: ColorRect = $DimBackground
@onready var tear_background: TextureRect = $TearBackground

var is_closing: bool = false

func _ready() -> void:
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	var screen_size = get_viewport().get_visible_rect().size

	# Generate jagged seam coordinates
	var seam_points = []
	var half_w = screen_size.x / 2.0
	var base_segment_length = screen_size.y / jagged_points
	
	for i in range(jagged_points + 1):
		var y = base_segment_length * i
		var x_offset = 0.0
		
		# Skip very top and very bottom points so edges stay perfectly aligned
		if i > 0 and i < jagged_points:
			# Randomize the vertical position
			y += randf_range(-vertical_variance, vertical_variance)
			
			# Force zigzag to switch between left and right
			var direction = 1 if i % 2 == 0 else -1
			
			# Apply  minimum and maximum distance constraints
			x_offset = randf_range(min_depth, max_depth) * direction
			
		seam_points.append(Vector2(half_w + x_offset, y))

	# Build Left Polygon
	var p_left = PackedVector2Array([Vector2(0, 0), Vector2(0, screen_size.y)])
	for i in range(jagged_points, -1, -1):
		p_left.append(seam_points[i])

	left_poly.texture = tex
	left_poly.polygon = p_left
	left_poly.uv = p_left

	# Build Right Polygon
	var p_right = PackedVector2Array([Vector2(screen_size.x, screen_size.y), Vector2(screen_size.x, 0)])
	for i in range(jagged_points + 1):
		p_right.append(seam_points[i])

	right_poly.texture = tex
	right_poly.polygon = p_right
	right_poly.uv = p_right

	# Hide UI and tear open
	ui_container.modulate.a = 0.0
	dim_background.modulate.a = 0.0
	open_animation()


# Functions below just have lots and lots of tweens, just ignore pretty please

func open_animation() -> void:
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(left_poly, "position:x", -rip_distance, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(right_poly, "position:x", rip_distance, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(dim_background, "modulate:a", 1.0, 0.4).set_delay(0.1)
	tween.tween_property(ui_container, "modulate:a", 1.0, 0.4).set_delay(0.1)

func close_animation() -> void:
	if is_closing: return
	is_closing = true

	var tween = create_tween().set_parallel(true)
	tween.tween_property(ui_container, "modulate:a", 0.0, 0.2)
	tween.tween_property(dim_background, "modulate:a", 0.0, 0.2)
	
	tween.tween_property(left_poly, "position:x", 0.0, 0.3).set_delay(0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(right_poly, "position:x", 0.0, 0.3).set_delay(0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	tween.chain().tween_callback(func(): UIManager.toggle_pause())

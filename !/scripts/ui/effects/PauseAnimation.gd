extends CanvasLayer

@export_category("tear Settings")
## How far the top and bottom cuts deviate from the exact center
@export var cut_tilt_offset: float = 100.0
## Overall Distance between the two parts
@export var rip_distance: float = 180.0

@export_category("Outline Settings")
## Outline Thiccness
@export var outline_width: float = 64.0
## Set Outline Color
@export var outline_color: Color = Color.WHITE


@onready var left_poly: Polygon2D = $LeftHalf
@onready var left_outline: Line2D = $LeftHalf/LeftOutline
@onready var right_poly: Polygon2D = $RightHalf
@onready var right_outline: Line2D = $RightHalf/RightOutline
@onready var ui_container: VBoxContainer = $VBoxContainer
@onready var dim_background: ColorRect = $DimBackground
@onready var tear_background: ColorRect = $TearBackground

var is_closing: bool = false

func _ready() -> void:
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	var screen_size = get_viewport().get_visible_rect().size
	
	var center_x = screen_size.x / 2.0
	
	# Calculate top and bottom x-coordinates for tilted cut
	var top_cut_x = center_x + cut_tilt_offset
	var bottom_cut_x = center_x - cut_tilt_offset
	
	# Build Left Polygon (Calc.Order-: Top-Left, Bottom-Left, Bottom-Cut, Top-Cut)
	var p_left = PackedVector2Array([
		Vector2(0, 0), 
		Vector2(0, screen_size.y),
		Vector2(bottom_cut_x, screen_size.y),
		Vector2(top_cut_x, 0)
	])
	
	left_poly.texture = tex
	left_poly.polygon = p_left
	left_poly.uv = p_left
	
	# Build Right Polygon (Bottom-Right, Top-Right, Top-Cut, Bottom-Cut)
	var p_right = PackedVector2Array([
		Vector2(screen_size.x, screen_size.y), 
		Vector2(screen_size.x, 0),
		Vector2(top_cut_x, 0),
		Vector2(bottom_cut_x, screen_size.y)
	])
	
	right_poly.texture = tex
	right_poly.polygon = p_right
	right_poly.uv = p_right
	
	# Setup Outlines
	var seam_points = PackedVector2Array([
		Vector2(top_cut_x, 0),
		Vector2(bottom_cut_x, screen_size.y)
	])
	
	left_outline.points = seam_points
	left_outline.width = outline_width
	left_outline.default_color = outline_color
	
	right_outline.points = seam_points
	right_outline.width = outline_width
	right_outline.default_color = outline_color
	
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

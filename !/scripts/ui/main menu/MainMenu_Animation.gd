extends Control

## Duration of title animation
const TITLE_ANIM_DURATION: float = 1.0
## Duration of background animation
const BG_ANIM_DURATION: float = 1.0
## Duration of Button fade-in
const BUTTON_FADE_DURATION: float = 0.8
## Starts fading the buttons in after 75% of the background faded in
const BUTTON_START_PERCENT: float = 0.75 # 

# ignore, its for the animations
const MAX_PROGRESS_VALUE: float = 100.0
const MIN_PROGRESS_VALUE: float = 0.0
const VISIBLE_ALPHA: float = 1.0
const HIDDEN_ALPHA: float = 0.0

# State tracking for the clicks
enum MenuState {
	WAITING_FIRST_CLICK,
	TITLE_ANIMATING,
	WAITING_SECOND_CLICK,
	FINISHING_SEQUENCE,
	DONE
}

@export_category("UI Elements")
@export var title_sprite: TextureProgressBar
@export var background_sprites: Array[TextureProgressBar]
@export var menu_buttons: Array[Button]

var current_state: MenuState = MenuState.WAITING_FIRST_CLICK

func _ready() -> void:
	if title_sprite:
		title_sprite.value = MIN_PROGRESS_VALUE
		title_sprite.modulate.a = VISIBLE_ALPHA 
		
	for bg in background_sprites:
		if bg:
			bg.value = MIN_PROGRESS_VALUE
			bg.modulate.a = VISIBLE_ALPHA
			
	for btn in menu_buttons:
		if btn:
			btn.modulate.a = HIDDEN_ALPHA
			btn.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or event.is_action_pressed("ui_accept"):
		match current_state:
			MenuState.WAITING_FIRST_CLICK:
				reveal_title()
			MenuState.WAITING_SECOND_CLICK:
				reveal_menu()

func reveal_title() -> void:
	current_state = MenuState.TITLE_ANIMATING
	var tween = create_tween()
	
	if title_sprite:
		tween.tween_property(title_sprite, "value", MAX_PROGRESS_VALUE, TITLE_ANIM_DURATION)
		
	tween.tween_callback(func(): current_state = MenuState.WAITING_SECOND_CLICK)

func reveal_menu() -> void:
	current_state = MenuState.FINISHING_SEQUENCE
	var tween = create_tween()
	tween.set_parallel(true)
	for bg in background_sprites:
		if bg:
			tween.tween_property(bg, "value", MAX_PROGRESS_VALUE, BG_ANIM_DURATION)
	
	var delay_time = BG_ANIM_DURATION * BUTTON_START_PERCENT
	for btn in menu_buttons:
		if btn:
			tween.tween_property(btn, "modulate:a", VISIBLE_ALPHA, BUTTON_FADE_DURATION).set_delay(delay_time)
	
	tween.chain().tween_callback(enable_buttons)

func enable_buttons() -> void:
	current_state = MenuState.DONE
	for btn in menu_buttons:
		if btn:
			btn.mouse_filter = Control.MOUSE_FILTER_STOP

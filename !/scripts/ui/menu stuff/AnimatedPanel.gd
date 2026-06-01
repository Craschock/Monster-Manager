extends Control
class_name AnimatedPanel

@export_category("Panel Animations")
## The background to fade in
@export var bg_progress: TextureProgressBar
## All other elements to fade in
@export var ui_elements: Array[Control] 

const ANIM_DURATION = 0.8
const UI_FADE_DURATION = 0.3

var active_tween: Tween

func _ready() -> void:
	# Hide everything on startup
	if bg_progress: bg_progress.value = 0.0
	for elem in ui_elements:
		if elem: elem.modulate.a = 0.0
	hide()

func open_panel() -> void:
	show()
	if active_tween and active_tween.is_valid():
		active_tween.kill()

	active_tween = create_tween()
	
	# fade in background
	if bg_progress:
		active_tween.tween_property(bg_progress, "value", 50.0, ANIM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Afterwards, fade in other stuff
	active_tween.chain().set_parallel(true)
	for elem in ui_elements:
		if elem:
			active_tween.tween_property(elem, "modulate:a", 1.0, UI_FADE_DURATION)

func close_panel() -> void:
	if active_tween and active_tween.is_valid():
		active_tween.kill()
		
	active_tween = create_tween().set_parallel(true)
	
	# Fade out the UI quickly
	for elem in ui_elements:
		if elem:
			active_tween.tween_property(elem, "modulate:a", 0.0, 0.2)
	
	# Fade background out
	if bg_progress:
		active_tween.chain().tween_property(bg_progress, "value", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		
	active_tween.chain().tween_callback(hide)

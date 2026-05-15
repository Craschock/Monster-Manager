extends Node

signal dragon_clicked(dragon: Dragon)

func _ready() -> void:
	for child in get_children():
		var dragon = child as Dragon
		dragon.dragon_clicked.connect(_on_dragon_clicked)
		
func _on_dragon_clicked(dragon: Dragon):
	dragon_clicked.emit(dragon)

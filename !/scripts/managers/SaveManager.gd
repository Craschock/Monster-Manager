extends Node

@export_category("Save Config")
const SAVE_PATH: String = "user://highscores.json"

# Storing scores in an array
var high_scores: Array = []

func _ready() -> void:
	load_scores()

# Add new score, sort the list, and save to disk
func save_score(new_score: int) -> void:
	high_scores.append(new_score)
	
	# Sort highest to lowest
	high_scores.sort_custom(func(a, b): return a > b)
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(high_scores))
		file.close()

# Reads the file and fills the array
func load_scores() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		
		var parsed_data = JSON.parse_string(content)
		if parsed_data is Array:
			high_scores = parsed_data

# Wipes the array and the saved file
func clear_scores() -> void:
	high_scores.clear()
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify([])) # Saves an empty array
		file.close()

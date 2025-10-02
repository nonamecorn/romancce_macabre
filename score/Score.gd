extends Node

const SCORE_PATH = "user://score"

var in_game: bool = false

var global_score: int = 0
var max_score: int = 0
var score: int = 0

func _ready() -> void:
	load_score()

func load_score():
	var file_exists = FileAccess.file_exists(SCORE_PATH)
	if file_exists:
		var fa := FileAccess.open(SCORE_PATH, FileAccess.READ)
		file_exists = not fa.get_length() == 0
		fa.close()
	if not file_exists:
		save_score()
		return
	var fa := FileAccess.open(SCORE_PATH, FileAccess.READ)
	global_score = fa.get_64()
	max_score = fa.get_64()
	score = 0
	fa.close()

## Applies the score and saves it to a file
func save_score():
	global_score += score
	max_score = max(max_score, score)
	score = 0
	var fa := FileAccess.open(SCORE_PATH, FileAccess.WRITE)
	fa.store_64(global_score)
	fa.store_64(max_score)
	fa.flush()
	fa.close()

func disconnect_all(s: Signal):
	for c in s.get_connections():
		s.disconnect(c)
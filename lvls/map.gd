extends Node2D

var endgame := false

func finish():
	if Score.score > 300:
		$won.show()
		$win.play()
	else:
		$loss.play()
		$lost.show()
	Score.save_score()
	var game = get_node_or_null(^"/root/Game")
	if game:
		game.endgame = true
	get_tree().paused = true

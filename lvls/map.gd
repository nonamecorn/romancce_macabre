extends Node2D

func finish():
	Score.save_score()
	if Score.score > 300:
		$won.show()
		$win.play()
	else:
		$loss.play()
		$lost.show()
	get_tree().paused = true

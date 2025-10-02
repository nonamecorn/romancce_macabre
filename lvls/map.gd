extends Node2D

func finish():
	Score.save_score()
	if Score.score > 300:
		$CanvasLayer/won.show()
		$win.play()
	else:
		$loss.play()
		$CanvasLayer/lost.show()
	get_tree().paused = true

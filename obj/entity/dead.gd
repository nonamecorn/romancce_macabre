extends DeathState

@export var dsnd : AudioStreamPlayer2D

func enter():
	super()
	dsnd.play()
	Score.score -= 30
	$Timer.start()


func _on_timer_timeout() -> void:
	transitioned.emit(self, "walk")

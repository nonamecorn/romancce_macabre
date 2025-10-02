extends DeathState

@export var dsnd : AudioStreamPlayer2D

func enter():
	super()
	dsnd.play()

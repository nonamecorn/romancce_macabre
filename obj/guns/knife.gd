extends Item

func use():
	$AnimationPlayer.play("kill")
func stop_use():
	$AnimationPlayer.stop()

extends State

@export var animation : AnimatedSprite2D
@export var hurtbox : Area2D

func enter():
	animation.play("attack")
func exit():
	animation.play("walk")


func _on_body_sprite_animation_finished() -> void:
	hurtbox.hurt()
	transitioned.emit(self, "patrol")


func _on_timer_timeout() -> void:
	pass

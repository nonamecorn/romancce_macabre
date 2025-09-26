extends StaticBody2D

signal damaged(damage : float, damage_vec : Vector2)

func hurt(damage, damage_vec):
	damaged.emit(damage, damage_vec)

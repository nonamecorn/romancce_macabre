extends Node2D

@export var damage : float = 10
@export var knockback : float = 10
@export var noise_radius: float = 500.0
@onready var rng = RandomNumberGenerator.new()
@export var player_handled = false
var firing = false
var state = FIRE
enum {
	FIRE,
	STOP,
}

func _ready() -> void:
	$THUMP.set_radius(noise_radius)
	rng.randomize()

func _process(_delta: float) -> void:
	if !player_handled: return
	if Input.is_action_just_pressed("l_click"):
		start_fire()
	if Input.is_action_just_released("l_click"):
		stop_fire()

func start_fire():
	if state: return
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("fire")
	firing = true

func stop_fire():
	if state:
		return
	firing = false

func fire():
	for body in $DamageBox.get_overlapping_bodies():
		if body.has_method("hurt"):
			$THUMP.bang()
			var d_vec : Vector2 = body.global_position - global_position
			body.hurt(damage, d_vec.normalized()*knockback)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if firing and anim_name == "fire":
		$AnimationPlayer.play("fire")

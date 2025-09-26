extends Node2D
class_name Gun

@export var default_modules : Dictionary[String,PackedScene]
@export var max_spread: float
@export var min_spread: float
@export var max_ammo: int
@export var num_of_pellets: int
@export var bullet_obj: PackedScene
@export var brass_texture: Texture
@export var ver_recoil: float
@export var hor_recoil: float
@export var noise_radius: float = 500.0
@onready var rng = RandomNumberGenerator.new()
@export var player_handled = false
func _ready() -> void:
	#if current_animation_length > 0.225:
		#speed_scale = current_animation_length
	$BANG.set_radius(noise_radius)
	ammo = max_ammo
	rng.randomize()
	for module in default_modules.values():
		add_part(module)
	
func _process(_delta: float) -> void:
	if !player_handled: return
	if Input.is_action_just_pressed("r_click"):
		start_fire()
	if Input.is_action_just_released("r_click"):
		stop_fire()
	if Input.is_action_just_pressed("reload"):
		reload()
var spread_tween
var spread = 0
var ammo
var firing = false
var state = FIRE
enum {
	FIRE,
	STOP,
}
signal empty
signal loaded
signal ammo_changed(current,max,ind)

func add_part(node : PackedScene):
	#var node = load(node)
	var node_inst = node.instantiate()
	$gun_container/modules.find_child(node_inst.type).add_child(node_inst)

func reset_part(part_name):
	var slot = $gun_container/modules.find_child(part_name)
	if slot.get_child_count() == 1:
		slot.get_child(0).queue_free()
	if slot is Marker2D:
		var node_inst = default_modules[part_name].instantiate()
		slot.add_child(node_inst)

func start_fire():
	if state: return
	if ammo <= 0:
		empty.emit()
		#if player_handled: ^/out_of_ammo.play()
		return
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("fire")
	firing = true
	if spread_tween: spread_tween.kill()
	spread_tween = create_tween()
	spread_tween.tween_property(self, "spread", max_spread, $firerate.wait_time*max_ammo)

func stop_fire():
	if state:
		return
	firing = false
	if spread_tween: spread_tween.kill()
	spread_tween = create_tween()
	spread_tween.tween_property(self, "spread", min_spread, $firerate.wait_time*max_ammo)
	#gpuparticles.emitting = false
	$firerate.stop()

func reset_spread():
	spread = min_spread
	if spread_tween: spread_tween.kill()

func reload():
	if ammo == max_ammo: return
	stop_fire()
	state = STOP
	if player_handled:
		ammo = 0
		display_ammo()
		#^/reload_start_cue.play()
	$reload.start()
	spread = min_spread

func _on_reload_timeout():
	stop_fire()
	ammo = max_ammo
	#if player_handled: ^/reload_end_cue.play()
	#$MAG.show()
	state = FIRE
	loaded.emit()
	display_ammo()

func display_ammo():
	ammo_changed.emit(ammo,max_ammo,get_index())

func fire():
	if state: return
	for i in num_of_pellets:
		if ammo <= 0:
			#gpuparticles.emitting = false
			$AnimationPlayer.stop()
			empty.emit()
			return
		ammo -= 1
		display_ammo()
		$BANG.bang()
		$BARREL.get_child(0).fire(bullet_obj, ver_recoil, hor_recoil)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if firing and anim_name == "fire":
		$AnimationPlayer.play("fire")

#func eject_brass():
	#var brass_inst = brass_obj.instantiate()
	#brass_inst.global_position = $gun_container/ejector.global_position
	#brass_inst.global_rotation = global_rotation + rng.randf_range(-PI/8, PI/8)
	#brass_inst.get_child(0).texture = brass_texture
	#added_velocity = get_parent().get_parent().get_parent().velocity/2
	#get_tree().current_scene.call_deferred("add_child",brass_inst)
	##brass_inst.init(added_velocity, lifetime)

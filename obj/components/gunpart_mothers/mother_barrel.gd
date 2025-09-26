extends Module
class_name Barrel


#var gun_resourcesd
var spread_tween
@export var max_spread: float
@export var min_spread: float
@export var lifetime: float = 1.0
@export var player_handled = false
var ammo
var brass_obj = preload("res://obj/components/brass.tscn")
var spread = 0
var added_velocity : Vector2
var offhand : bool = false
var state = FIRE
var cursor
var body
enum {
	FIRE,
	STOP,
}
#var gpuparticles
var assambled = false
#@export var pitch_shifing : Curve
var firing = false

signal empty
signal loaded
signal ammo_changed(current,max,ind)

#var falloff : Curve
#var firing_strategies = []
#var bullet_strategies = []

#var silenced = false

#var enabled : bool = false

#func enable():
	#state = FIRE
#func disable():
	#state = STOP

#func get_current_animation_length():
	#current_animation_length






#func dispawn_facade(part_name):
	#var slot = find_child(part_name)
	#if slot.get_child_count() == 0: return
	#for child in slot.get_children():
		#child.queue_free()
	#slot.position = Vector2.ZERO





#func wear_down():
	#for part in gun_resources:
		#if !gun_resources[part]: continue
		#gun_resources[part].curr_durability -= wear

#func weapon_functional():
	#for part in gun_resources:
		#if !gun_resources[part]: continue
		#if gun_resources[part].curr_durability <= 0:
			#gun_resources[part].destry_item()
			#return false
	#return true

#func get_pitch() -> float:
	#if ammo <= 20:
		#return pitch_shifing.sample(ammo)
	#if !silenced:
		#return rng.randf_range(0.9,1.1)
	#else:
		#return rng.randf_range(0.5,1.5)

func _ready() -> void:
	spread = min_spread
	#if current_animation_length > 0.225:
		#speed_scale = current_animation_length
	

func get_pof() -> Vector2:
	return $POF.global_position
func fire(bullet_obj: PackedScene, ver_recoil: float, hor_recoil: float):
	#wear_down()
	#if !silenced:
		#$AnimationPlayer.play("fire")
		#^/shoting.pitch_scale = get_pitch()
		#^/shoting.play()
	#else:
		#^/silenced_shooting.pitch_scale = get_pitch()
		#^/silenced_shooting.play()
	var bullet_inst = bullet_obj.instantiate()
	bullet_inst.global_rotation_degrees = global_rotation_degrees + randf_range(-spread, spread)
	added_velocity = body.velocity
	#bullet_inst.falloff = falloff
	#bullet_inst.max_range = the_range     /////do this one!!!
	#for strategy in bullet_strategies:
		#bullet_inst.strategies.append(strategy)
	#for strategy in firing_strategies:
		#strategy.apply_strategy(bullet_inst, self)
	bullet_inst.mod_vec = added_velocity
	bullet_inst.lifetime = lifetime
	get_tree().current_scene.call_deferred("add_child",bullet_inst)
	bullet_inst.global_position = get_pof()
	bullet_inst.global_rotation_degrees = global_rotation_degrees  + randf_range(-spread, spread)
	var recoil_vector = Vector2(-ver_recoil,randf_range(-hor_recoil, hor_recoil))
	cursor.apply_recoil(recoil_vector)
	muzzle_flash()
	#firing = true
	#$single_shot.start()
	#await $single_shot.timeout
	#firing = false
	
	#if !weapon_functional():
		#^/something_broke.play()
		#display_ammo()
		#stop_fire()


#func _on_single_shot_timeout() -> void:
	#gpuparticles.emitting = false


func muzzle_flash():
	var muzzle_inst = preload("res://obj/components/gunplay/muzzle_flash.tscn").instantiate()
	muzzle_inst.global_position = get_pof()
	get_tree().current_scene.call_deferred("add_child",muzzle_inst)

extends Node2D
class_name Module

@export_enum("MUZZLE", "ATTACH", "BARREL", "AMMO", "BOLT") var type: String
@export var changes: Array[Change]

#func apply_changes(changes : Array[Change]):
	#for change in changes:
		#if change.is_set:
			#set(change.stat_name, change.value_of_stat)
			#continue
		#change_stat(change.stat_name, change.value_of_stat, change.mult)
#func change_stat(name_of_stat : String, value_of_stat, mult: bool):
	#var temp = get(name_of_stat)
	#if mult:
		#set(name_of_stat, temp*value_of_stat)
		#return
	#set(name_of_stat, temp+value_of_stat)

func enter():
	pass

func exit():
	pass

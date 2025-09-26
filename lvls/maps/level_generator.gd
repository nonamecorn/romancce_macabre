extends Node2D

class_name LevelGenerator

var connectors = []
var rects = []

@export var roomcount : int = 5
@export var debug : bool = false

@export var rooms : Array[PackedScene]
@export var exit : PackedScene

func get_connectors():
	return get_tree().get_nodes_in_group("connector")

func _ready() -> void:
	rects.append($rooms/room1.get_rect())
	if !debug: 
		$Camera2D.enabled = false

func room_fits(room_rect):
	for rect in rects:
		if room_rect.intersects(rect):
			return false
	return true

func start_spawning():
	pass
	#while roomcount != 0:
		#rooms.shuffle()
		#spawn_room(rooms[0])
	#while roomcount == 0:
		#spawn_room(exit_obj_path)
	#get_connectors()
	#for connector in connectors:
		##if exit.active: continue
		#connector.queue_free()
	

func spawn_room(room : PackedScene):
	connectors = get_connectors()
	connectors.shuffle()
	var connector = connectors.pop_front()
	var room_inst = room.instantiate()
	$rooms.add_child(room_inst)
	room_inst.global_position = connector.global_position
	var connector2 = room_inst.align_random(connector.get_inverse())
	var room_rect = room_inst.get_rect()
	if room_fits(room_rect):
		connector.queue_free()
		connector2.queue_free()
		rects.append_array([room_rect])
		roomcount -= 1
	else:
		room_inst.queue_free()
		#var opposite_marker = room_inst.find_child("markers").get_child(connector_to_destroy)
		#opposite_marker.deactivate()
		#connector.deactivate()
		#rects.append_array([room_rect, corr_rect])
		#authorize_access(room_inst.markers)
		#opposite_marker.get_info()
		#roomcount -= 1
	#get_exits()
	#exits.reverse()
	#var head = exits.slice(0,3)
	#head.shuffle()
	#var connector = head[0]
	#var connector_info = connector.get_info()
	#if !connector_info:
		#return
	#var corr_inst
	#var connector_to_destroy
	#match connector_info.orientation:
		#0: 
			#corr_inst = corr_north_obj.instantiate()
			#connector_to_destroy = 3
		#1: 
			#corr_inst = corr_west_obj.instantiate()
			#connector_to_destroy = 2
		#2: 
			#corr_inst = corr_east_obj.instantiate()
			#connector_to_destroy = 1
		#3: 
			#corr_inst = corr_south_obj.instantiate()
			#connector_to_destroy = 0
	#corr_inst.global_position = connector_info.position - corr_inst.get_child(0).position
	#var corr_connector = corr_inst.get_child(0).get_child(0)
	#$ysort/modules.add_child(corr_inst)
	#var room_inst = load(room).instantiate()
	#room_inst.global_position = corr_connector.global_position
	#$ysort/modules.add_child(room_inst)
	#room_inst.align(connector_info.orientation)
	#var room_rect = room_inst.get_rect()
	##room_rect.position = room_rect.position
	#var corr_rect = corr_inst.get_rect()
	#if room_fits(room_rect,corr_rect):
		#var opposite_marker = room_inst.find_child("markers").get_child(connector_to_destroy)
		#opposite_marker.deactivate()
		#connector.deactivate()
		#rects.append_array([room_rect, corr_rect])
		#authorize_access(room_inst.markers)
		#opposite_marker.get_info()
		#roomcount -= 1
	#else:
		#connector.close()
		#room_inst.queue_free()
		#corr_inst.queue_free()


func _on_timer_timeout() -> void:
	if roomcount == 0:
		spawn_room(exit)
	else:
		rooms.shuffle()
		spawn_room(rooms[0])
	if roomcount < 0:
		$Timer.stop()

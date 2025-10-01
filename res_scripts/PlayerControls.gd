extends Resource

class_name PlayerControls #used for multiple players controls

@export var player_index : int  = 0
@export var keyboard : bool = true
@export var up : String = "p1_up" #this is action
@export var left : String = "p1_left"
@export var down : String = "p1_down"
@export var right : String = "p1_right"
@export var look_up : String = "p1_look_up"
@export var look_left : String = "p1_look_left"
@export var look_down : String = "p1_look_down"
@export var look_right : String = "p1_look_right"
@export var pick : String = "p1_grab"
@export var use : String = "p1_use"

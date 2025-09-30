extends Resource

class_name PlayerControls #used for multiple players controls

@export var player_index : int  = 0
@export var keyboard : bool = true
@export var left : String = "p1_left" #this is action
@export var right : String = "p1_right"
@export var up : String = "p1_up"
@export var down : String = "p1_down"
@export var pick : String = "p1_grab"
@export var use : String = "p1_use"

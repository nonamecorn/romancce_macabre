extends Node

@onready var players = {
	1: {
		viewport = $GridContainer/SubViewportContainer2/SubViewport,
		camera = $GridContainer/SubViewportContainer2/SubViewport/Camera2D,
		player = $GridContainer/SubViewportContainer2/SubViewport/map/Player
	},
	2: {
		viewport = $GridContainer/SubViewportContainer/SubViewport,
		camera = $GridContainer/SubViewportContainer/SubViewport/Camera2D2,
		player = $GridContainer/SubViewportContainer2/SubViewport/map/Player2
	},
}

func _ready() -> void:
	Main.current_level = $GridContainer/SubViewportContainer2/SubViewport/map
	players[2].viewport.world_2d = players[1].viewport.world_2d
	for node in players.values():
		var remote_trans := RemoteTransform2D.new()
		remote_trans.remote_path = node.camera.get_path()
		node.player.add_child(remote_trans)

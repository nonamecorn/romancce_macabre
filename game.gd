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
		player = $GridContainer/SubViewportContainer2/SubViewport/map/bobot
	},
	3: {
		viewport = $GridContainer/SubViewportContainer3/SubViewport,
		camera = $GridContainer/SubViewportContainer3/SubViewport/Camera2D2,
		player = $GridContainer/SubViewportContainer2/SubViewport/map/bobot2
	},
	4: {
		viewport = $GridContainer/SubViewportContainer4/SubViewport,
		camera = $GridContainer/SubViewportContainer4/SubViewport/Camera2D2,
		player = $GridContainer/SubViewportContainer2/SubViewport/map/bobot3
	},
}

func _ready() -> void:
	Main.current_level = $GridContainer/SubViewportContainer2/SubViewport/map
	players[2].viewport.world_2d = players[1].viewport.world_2d
	players[3].viewport.world_2d = players[1].viewport.world_2d
	players[4].viewport.world_2d = players[1].viewport.world_2d
	for node in players.values():
		var remote_trans := RemoteTransform2D.new()
		remote_trans.remote_path = node.camera.get_path()
		node.player.add_child(remote_trans)

func _process(_delta: float) -> void:
	$"CenterContainer/Label".text = str(Score.score)

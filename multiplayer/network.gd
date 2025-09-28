extends Node2D

const IP_ADRESS:= "localhost"
const PORT:= 42069

var peer : ENetMultiplayerPeer

func _ready() -> void:
	Main.current_level = self

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 4)
	multiplayer.multiplayer_peer = peer


func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer

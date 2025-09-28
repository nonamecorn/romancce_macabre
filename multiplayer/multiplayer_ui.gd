extends Control


func _on_server_pressed() -> void:
	Network.start_server()


func _on_client_pressed() -> void:
	Network.start_client()

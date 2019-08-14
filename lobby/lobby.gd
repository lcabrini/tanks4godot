extends Node2D

var player_info = {}

func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnected')
	
func _on_Host_pressed():
	$Join.disabled = true
	Network.host_game()
	
func _on_Join_pressed():
	Network.join_game()
	
func _on_Nickname_text_changed(new_text):
	if $Control/Nickname.text == '':
		$Join.disabled = true
		$Host.disabled = true
	else:
		$Join.disabled = false
		$Host.disabled = false
		
func _player_connected(id):
	var info = {nickname=$Control/Nickname.text}
	rpc_id(id, "register_player", info)
	
func _player_disconnected(id):
	player_info.erase(id)
	
func _connected_ok():
	print("something")
	
func _connected_fail():
	pass
	
func _server_disconnected():
	pass
	
remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = info
	print("Registered player " + info.nickname)
#func _update_player_count():
#	print("players: " + str(len(Network.players)))
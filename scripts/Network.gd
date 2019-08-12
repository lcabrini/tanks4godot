extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 4

var players = {}
var player = {nickname='', position=Vector2(360, 100)}

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	
func create_server(nickname):
	player.nickname = nickname
	players[1] = player
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	
func connect_to_server(nickname):
	player.nickname = nickname
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
func _connected_to_server():
	players[get_tree().get_network_unique_id()] = player
	rpc('send_player_info', get_tree().get_network_unique_id(), player)
	
func _player_connected(id):
	print("Player connected: " + str(id))
	
func _player_disconnected(id):
	print("Player disconnected: " + str(id))
	
remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	players[id] = info
	
	var new_player = load('res://tanks/Player.tscn')
	new_player.nickname = str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	new_player.init(info.nickname, info.position, true)
	
func update_position(id, position):
	players[id].position = position
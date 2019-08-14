extends Node

const DEFAULT_PORT = 14000
const MAX_PEERS = 5

signal server_created()
signal connection_succeeded()
signal connection_failed()
signal player_list_changed()

var nickname = ''
var players = {}

func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnected')

func host_game(new_nickname):
	print("in host_game")
	nickname = new_nickname
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
	emit_signal("server_created")
	
func join_game(ip, new_nickname):
	print("in join_game")
	nickname = new_nickname
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host) 
	
remote func register_player(nickname):
	print("in register player")
	var id = get_tree().get_rpc_sender_id()
	players[id] = nickname
	emit_signal("player_list_changed")
	
func unregister_player(id):
	players.erase(id)
	
func _player_connected(id):
	print("player connected: " + str(id))
	rpc_id(id, "register_player", nickname)
	
func _player_disconnected(id):
	print("player disconnected: " + str(id))
	
func _connected_ok():
	print("connection OK.")
	
func _connected_fail():
	get_tree().set_network_peer(null)
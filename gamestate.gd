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
	print("in register player, nickname: " + nickname)
	var id = get_tree().get_rpc_sender_id()
	print("id is " + str(id))
	players[id] = nickname
	emit_signal("player_list_changed")
	
func unregister_player(id):
	players.erase(id)
	
func start_game():
	assert(get_tree().is_network_server())
	var spawn_points = {}
	spawn_points[1] = 0
	var spawn_points_idx = 1
	for p in players:
		spawn_points[p] = spawn_points_idx
		spawn_points_idx += 1
	for p in players:
		rpc_id(p, "prepare_game", spawn_points)
	prepare_game(spawn_points)
	
remote func prepare_game(spawn_points):
	var map = load("res://maps/map01.tscn").instance()
	var map_limits = map.get_node('ground').get_used_rect()
	var map_cellsize = map.get_node('ground').cell_size
	get_tree().get_root().add_child(map)
	get_tree().get_root().get_node("lobby").hide()
	
	var player_scene = load('res://tanks/player.tscn')
	
	for p_id in spawn_points:
		var spawn_pos = map.get_node("spawn_points/" + str(spawn_points[p_id])).position
		var player = player_scene.instance()
		player.position = spawn_pos
		player.set_name(str(p_id))
		player.set_network_master(p_id)
		var cam = player.get_node('player_camera')
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y
		
		if p_id == get_tree().get_network_unique_id():
			player.set_player_name(nickname)
		else:
			player.set_player_name(players[p_id])
		map.add_child(player)
		
func _player_connected(id):
	print("player connected: " + str(id))
	rpc_id(id, "register_player", nickname)
	
func _player_disconnected(id):
	print("player disconnected: " + str(id))
	
func _connected_ok():
	print("connection OK.")
	
func _connected_fail():
	get_tree().set_network_peer(null)
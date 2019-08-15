extends Control

func _ready():
	gamestate.connect('connection_succeeded', self, '_on_connection_success')
	gamestate.connect('connection_failed', self, '_on_connection_failed')
	gamestate.connect('server_created', self, '_on_server_created')
	gamestate.connect('player_list_changed', self, '_on_player_list_changed')
	
func _on_connection_success():
	pass
	
func _on_connection_failed():
	pass

func _on_server_created():
	get_node('host').disabled = true
	get_node('status').text = "Server started. Waiting for players to join..."

func _on_nickname_text_changed(new_text):
	if new_text == '':
		get_node('host').disabled = true
	else:
		get_node('host').disabled = false

func _on_host_pressed():
	var nickname = get_node('nickname').text
	gamestate.host_game(nickname)
	
func _on_join_pressed():
	var nickname = get_node('nickname').text
	var server = get_node('server').text
	gamestate.join_game(server, nickname)

func _on_server_text_changed(new_text):
	if new_text == '':
		get_node('join').disabled = true
	else:
		get_node('join').disabled = false

func _on_player_list_changed():
	var player_count = len(gamestate.players)
	get_node('status').text = str(player_count) + " players connected."
	if get_tree().is_network_server():
		get_node("start").show()



extends Control

var joined

func _ready():
	gamestate.connect('connection_succeeded', self, '_on_connection_success')
	gamestate.connect('connection_failed', self, '_on_connection_failed')
	gamestate.connect('server_created', self, '_on_server_created')
	gamestate.connect('joined_game', self, '_on_joined_game')
	gamestate.connect('player_list_changed', self, '_on_player_list_changed')
	joined = false
	get_node('nickname').grab_focus()
	get_node('player').play()
	
func _on_connection_success():
	pass
	
func _on_connection_failed():
	pass

func _on_server_created():
	#get_node('host').disabled = true
	joined = true
	_update()
	get_node('status').text = "Server started. Waiting for players to join..."
	
func _on_joined_game():
	#get_node('join').disabled = true
	#get_node('host').disabled = true
	joined = true
	_update()
	
func _on_nickname_text_changed(new_text):
	_update()
	#if new_text == '':
	#	get_node('host').disabled = true
	#	get_node('join').disabled = true
	#else:
	#	get_node('host').disabled = false
	#	if get_node('server').text != '':
	#		get_node('join').disabled = false
	#	else:
	#		get_node('join').disabled = true

func _on_host_pressed():
	var nickname = get_node('nickname').text
	gamestate.host_game(nickname)
	
func _on_join_pressed():
	var nickname = get_node('nickname').text
	var server = get_node('server').text
	gamestate.join_game(server, nickname)

func _on_server_text_changed(new_text):
	_update()
	#if new_text == '':
	#	get_node('join').disabled = true
	#else:
	#	get_node('join').disabled = false

func _on_player_list_changed():
	var player_count = len(gamestate.players)
	get_node('status').text = str(player_count) + " players connected."
	if get_tree().is_network_server():
		get_node("start").show()

func _on_start_pressed():
	gamestate.start_game()

func _update():
	if joined:
		get_node('nickname').editable = false
		get_node('server').editable = false
		get_node('host').disabled = true
		get_node('join').disabled = true
	else:
		var ip = get_node('server').text
		if not ip.is_valid_ip_address() or get_node('nickname').text == '':
			get_node('join').disabled = true
		else:
			get_node('join').disabled = false
		
		if get_node('nickname').text == '':
			get_node('host').disabled = true
		elif ip != '':
			get_node('host').disabled = true
		else:
			get_node('host').disabled = false
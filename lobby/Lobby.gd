extends Node2D

var player_count = 0

func _on_Host_pressed():
	$Join.disabled = true
	Network.create_server($Control/Nickname.text)
	_add_player()
	
func _on_Join_pressed():
	Network.connect_to_server($Control/Nickname.text)
	_add_player()

func _on_Nickname_text_changed(new_text):
	if $Control/Nickname.text == '':
		$Join.disabled = true
		$Host.disabled = true
	else:
		$Join.disabled = false
		$Host.disabled = false
		
#func _load_map():
#	get_tree().change_scene('res://maps/Map01.tscn')

func _add_player():
	player_count += 1
	print("Player count: " + str(player_count))
	if player_count > 1:
		$Start.visible = true
extends Node2D

func _ready():
	Network.connect('player_count_changed', self, '_update_player_count')

func _on_Host_pressed():
	$Join.disabled = true
	Network.create_server($Control/Nickname.text)
	
func _on_Join_pressed():
	Network.connect_to_server($Control/Nickname.text)

func _on_Nickname_text_changed(new_text):
	if $Control/Nickname.text == '':
		$Join.disabled = true
		$Host.disabled = true
	else:
		$Join.disabled = false
		$Host.disabled = false
		
#func _load_map():
#	get_tree().change_scene('res://maps/Map01.tscn')
		
func _update_player_count():
	print("players: " + str(len(Network.players)))
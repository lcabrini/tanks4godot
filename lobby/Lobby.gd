extends Node2D

func _on_Host_pressed():
	$Join.disabled = true
	network.create_server($Control/Nickname.text)
	_load_map()
	
func _on_Join_pressed():
	network.connect_to_server($Control/Nickname.text)
	_load_map()

func _on_Nickname_text_changed(new_text):
	if $Control/Nickname.text == '':
		$Join.disabled = true
		$Host.disabled = true
	else:
		$Join.disabled = false
		$Host.disabled = false
		
func _load_map():
	get_tree().change_scene('res://maps/Map01.tscn')


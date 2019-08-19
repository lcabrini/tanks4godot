extends Node2D

#func _ready():
#	var new_player = preload('res://tanks/player.tscn').instance()
#	new_player.name = str(get_tree().get_network_unique_id())
#	new_player.set_network_master(get_tree().get_network_unique_id())
#	get_tree().get_root().add_child(new_player)
	#new_player.init(info.nickname, info.position, false)
#	if is_network_master():
#		set_camera_limits()
	
#func set_camera_limits():
#	var map_limits = get_node('ground').get_used_rect()
	#var map_cellsize = get_node('ground').cell_size
	#var player = get_tree().get_network_unique_id()
	#var cam = get_node(str(player)).player_camera
	
	#cam.limit_left = map_limits.position.x * map_cellsize.x
	#cam.limit_right = map_limits.end.x * map_cellsize.x
	#cam.limit_top = map_limits.position.y * map_cellsize.y
	#cam.limit_bottom = map_limits.end.y * map_cellsize.y
	
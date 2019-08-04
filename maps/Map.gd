extends Node2D

func _ready():
	set_camera_limits()

func set_camera_limits():
	var map_limits = $Ground.get_used_rect()
	var map_cellsize = $Ground.cell_size
	var cam = $Player/Camera2D
	cam.limit_left = map_limits.position.x * map_cellsize.x
	cam.limit_right = map_limits.end.x * map_cellsize.x
	cam.limit_top = map_limits.position.y * map_cellsize.y
	cam.limit_bottom = map_limits.end.y * map_cellsize.y
	
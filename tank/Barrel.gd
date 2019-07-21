extends Area2D

func _process(delta):
	if Input.is_action_pressed("rotate_barrel_clockwise"):
		print("clock")
		rotation_degrees += 1
	elif Input.is_action_pressed("rotate_barrel_counter_clockwise"):
		print("anticlock")
		rotation_degrees -= 1
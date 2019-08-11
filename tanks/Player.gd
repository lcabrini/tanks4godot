extends "res://tanks/Tank.gd"

enum MovementKey {FORWARD, BACKWARD, STOPPED}
enum RotationKey {LEFT, RIGHT, NONE}

slave var slave_movement_key = MovementKey.STOPPED
slave var slave_rotation_key = RotationKey.NONE
slave var slave_position = Vector2()
slave var slave_turret_direction = Vector2()

func control(delta):
	pass
	
func _physics_process(delta):
	var movement_key = MovementKey.STOPPED
	var rotation_key = RotationKey.NONE
	var turret_direction = Vector2()
	
	if is_network_master():
		turret_direction = get_global_mouse_position()
		if Input.is_action_pressed('turn_right'):
			rotation_key = RotationKey.RIGHT
		elif Input.is_action_pressed('turn_left'):
			rotation_key = RotationKey.LEFT
		if Input.is_action_pressed('forward'):
			movement_key = MovementKey.FORWARD
		elif Input.is_action_pressed('back'):
			movement_key = MovementKey.BACKWARD
		
		rset_unreliable('slave_position', position)
		rset('slave_movement_key', movement_key)
		rset('slave_rotation_key', rotation_key)
		rset('slave_turret_direction', turret_direction)
	else:
		_move(slave_movement_key, slave_rotation_key, slave_turret_direction, delta)
		position = slave_position
	
	if get_tree().is_network_server():
		network.update_position(int(name), position)
		
func _move(movement_key, rotation_key, turret_direction, delta):
	$Turret.look_at(turret_direction)
	
	var rot_dir = 0
	if rotation_key == RotationKey.RIGHT:
			rot_dir += 1
	if rotation_key == RotationKey.LEFT:
		rot_dir -= 1
	rotation += rotation_speed * rot_dir * delta
	velocity = Vector2()
	if movement_key == MovementKey.FORWARD:
		velocity = Vector2(speed, 0).rotated(rotation)
	if movement_key == MovementKey.BACKWARD:
		velocity = Vector2(-speed/2, 0).rotated(rotation)
		
func init(nickname, start_position, is_slave):
	global_position = start_position
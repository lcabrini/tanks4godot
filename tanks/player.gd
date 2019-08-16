extends KinematicBody2D

const MOTION_SPEED = 90.0
const ROTATION_SPEED = 5

var velocity = Vector2()

puppet var puppet_pos = Vector2()
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0

func _ready():
	puppet_pos = position
	
	if is_network_master():
		get_node('player_camera').make_current()

func _physics_process(delta):
	var rot_dir = 0
		
	if is_network_master():
		get_node('turret').look_at(get_global_mouse_position())
		if Input.is_action_pressed("turn_left"):
			print("Turn left")
			rot_dir += 1
		if Input.is_action_pressed('turn_left'):
			rot_dir -= 1
		rotation += ROTATION_SPEED * rot_dir * delta
		velocity = Vector2()
		if Input.is_action_pressed('forward'):
			velocity = Vector2(MOTION_SPEED, 0).rotated(rotation)
		if Input.is_action_pressed('backward'):
			velocity = Vector2(-MOTION_SPEED/2, 0).rotated(rotation)
		rset('puppet_velocity', velocity)
		rset('puppet_rotation', rotation)
		rset('puppet_position', position)
	else:
		position = puppet_pos
		velocity = puppet_velocity
		rotation = puppet_rotation
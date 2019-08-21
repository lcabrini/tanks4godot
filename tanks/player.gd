extends KinematicBody2D

const MOTION_SPEED = 200.0
const ROTATION_SPEED = 1

var velocity = Vector2()

signal shoot()

#puppet var puppet_pos = Vector2()
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
puppet var puppet_turret_rotation = 0

func _ready():
	#puppet_pos = position
	puppet_rotation = rotation
	puppet_turret_rotation = 0
	$name.get_global_transform()
	
	if is_network_master():
		get_node('player_camera').make_current()
		print("_ready: network master")
	else:
		print("_ready: network client")
		
func set_player_name(new_name):
	#get_node('name').text = new_name
	get_node('details').get_node('name').text = new_name

sync func fire_missile(pos, dir, target):
	print("firing missile!")
	var missile = preload('res://missiles/missile.tscn').instance()
	missile.start(pos, dir, target)
	get_node('..').add_child(missile)
	
func _physics_process(delta):
	var rot_dir = 0
		
	if is_network_master():
		#print("control is master")
		get_node('turret').look_at(get_global_mouse_position())
		if Input.is_action_pressed("turn_right"):
			print("Turn right")
			rot_dir += 1
		if Input.is_action_pressed('turn_left'):
			print("turn left")
			rot_dir -= 1
		rotation += ROTATION_SPEED * rot_dir * delta
		velocity = Vector2()
		if Input.is_action_pressed('forward'):
			print("forward")
			velocity = Vector2(MOTION_SPEED, 0).rotated(rotation)
		if Input.is_action_pressed('reverse'):
			print("backward")
			velocity = Vector2(-MOTION_SPEED/2, 0).rotated(rotation)
		if Input.is_action_just_pressed('Click'):
			var dir = Vector2(1, 0).rotated(get_node('turret/muzzle').global_rotation)
			var pos = get_node('turret/muzzle').global_position
			var target = get_global_mouse_position()
			rpc('fire_missile', pos, dir, target)
		move_and_slide(velocity)
		rset('puppet_velocity', velocity)
		rset('puppet_rotation', rotation)
		#rset('puppet_position', position)
		rset('puppet_turret_rotation', get_node('turret').rotation)
	else:
		#position = puppet_pos
		velocity = puppet_velocity
		rotation = puppet_rotation
		get_node('turret').rotation = puppet_turret_rotation
		move_and_slide(velocity)
		#get_node('turret').look_at(puppet_turret_direction)
		#print("_physics_process: network client")

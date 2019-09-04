extends KinematicBody2D

const MOTION_SPEED = 200.0
const ROTATION_SPEED = 1
const MAX_HEALTH = 1000

var velocity = Vector2()
var health = MAX_HEALTH
var can_shoot = true

signal shoot()
signal health_changed(new_health)

puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
puppet var puppet_turret_rotation = 0

func _ready():
	puppet_rotation = rotation
	puppet_turret_rotation = 0
	$name.get_global_transform()
	health = MAX_HEALTH
	emit_signal('health_changed', health * 100 / MAX_HEALTH)
	get_node('gun_timer').wait_time = 0.6
	can_shoot = true
	
	if is_network_master():
		get_node('player_camera').make_current()
		print("_ready: network master")
	else:
		print("_ready: network client")
		
func set_player_name(new_name):
	get_node('details').get_node('name').text = new_name

sync func fire_missile(pos, dir, target, shooter):
	var missile = preload('res://missiles/missile.tscn').instance()
	missile.start(pos, dir, target)
	missile.shooter = shooter
	get_node('..').add_child(missile)
	get_node('animation').play('muzzle_flash')
	
func get_hit(damage):
	health -= damage
	emit_signal("health_changed", health * 100 / MAX_HEALTH)
	if health < 1:
		queue_free()
	
func _physics_process(delta):
	var rot_dir = 0
		
	if is_network_master():
		get_node('turret').look_at(get_global_mouse_position())
		if Input.is_action_pressed("turn_right"):
			rot_dir += 1
		if Input.is_action_pressed('turn_left'):
			rot_dir -= 1
		rotation += ROTATION_SPEED * rot_dir * delta
		velocity = Vector2()
		if Input.is_action_pressed('forward'):
			velocity = Vector2(MOTION_SPEED, 0).rotated(rotation)
		if Input.is_action_pressed('reverse'):
			velocity = Vector2(-MOTION_SPEED/2, 0).rotated(rotation)
		if Input.is_action_just_pressed('Click'):
			if can_shoot:
				can_shoot = false
				get_node('gun_timer').start()
				var dir = Vector2(1, 0).rotated(get_node('turret/muzzle').global_rotation)
				var pos = get_node('turret/muzzle').global_position
				var target = get_global_mouse_position()
				rpc('fire_missile', pos, dir, target, get_tree().get_network_unique_id())
		move_and_slide(velocity)
		rset('puppet_velocity', velocity)
		rset('puppet_rotation', rotation)
		rset('puppet_turret_rotation', get_node('turret').rotation)
	else:
		velocity = puppet_velocity
		rotation = puppet_rotation
		get_node('turret').rotation = puppet_turret_rotation
		move_and_slide(velocity)

func _on_gun_timer_timeout():
	can_shoot = true
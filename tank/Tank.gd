extends KinematicBody2D

const V_MAX = 300
const RA_MAX = 180
const ACC = 0.5
const DEC = 0.7

var v
var ra
var wall_hit
var damage = 0

func _ready():
	v = 0
	ra = 0
	wall_hit = false
	damage = 0
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		v += ACC
		if v > V_MAX:
			v = V_MAX
	elif v > 0:
		v -= DEC
		if v < 0:
			v = 0
			
	if v > 0:
		if not $EngineSound.is_playing():
			$EngineSound.play()
		if Input.is_action_pressed("ui_left"):
			ra -= 1
			if ra < -RA_MAX:
				ra = -RA_MAX
		elif Input.is_action_pressed("ui_right"):
			ra += 1
			if ra > RA_MAX:
				ra = RA_MAX
		elif ra != 0:
			if ra > 0:
				ra -= 1
			else:
				ra += 1
				
		rotation_degrees += ra * delta
		var dir = Vector2(0, -1).rotated(rotation)
		var motion = dir.normalized() * v
		move_and_slide(motion, Vector2(0, 0))
		var hit = get_slide_count() > 0
		if hit and not wall_hit:
			wall_hit = true
			if v > 150:
				damage += v / 100
				v = 0
				print("damage: " + str(damage))
		elif not hit and wall_hit:
			wall_hit = false
	else:
		ra = 0
		if $EngineSound.is_playing():
			$EngineSound.stop()
		
extends Area2D

var speed = 100
var target = Vector2()
var velocity = Vector2()

func start(_position, _direction, _target):
	position = _position
	rotation = _direction.angle()
	target = _target
	velocity = _direction * speed
	
func explode():
	queue_free()
	
func _process(delta):
	print("missile is flying...")
	print("target: " + str(target))
	print("position: " + str(position))
	if position.distance_to(target) <= 1:
		explode()
	else:
		position += velocity * delta
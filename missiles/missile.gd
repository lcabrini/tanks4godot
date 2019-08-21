extends Area2D

var speed = 100
var target = Vector2()
var velocity = Vector2()

func start(_position, _direction, _target):
	position = _position
	rotation = _direction.angle()
	target = _target
	velocity = _direction * speed
	
func _process(delta):
	print("missile is flying...")
	position += velocity * delta
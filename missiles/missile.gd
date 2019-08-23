extends Area2D

var speed = 300
var target = Vector2()
var velocity = Vector2()

func start(_position, _direction, _target):
	position = _position
	rotation = _direction.angle()
	target = _target
	velocity = _direction * speed
	
sync func explode():
	queue_free()
	#print("exploding")
	var explosion = preload("res://explosion/explosion.tscn").instance()
	explosion.start(position)
	get_node('..').add_child(explosion)
	
func _process(delta):
	#print("missile is flying...")
	#print("target: " + str(target))
	#print("position: " + str(position))
	if position.distance_to(target) <= 10:
		explode()
	else:
		position += velocity * delta
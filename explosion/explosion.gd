extends Area2D

var shooter

func start(_position):
	position = _position
	get_node('animation').playing = true
	get_node('sound').play()

func _on_explosion_finished():
	get_node("animation").playing = false
	queue_free()

func _on_explosion_body_entered(body):
	var distance = body.position.distance_to(position)
	var damage = 200 - distance
	if body.has_method('get_hit'):
		body.get_hit(damage)
extends Area2D

#var started

func start(_position):
	position = _position
	#get_node('animation').connect("finished", self, "on_explosion_done")
	get_node('animation').playing = true
	get_node('sound').play()
	#started = true
	
#func _process(delta):
#	var a = get_node('animation')
#	if started and not a.playing:
#		queue_free()

func _on_explosion_finished():
	#print("done exploding")
	get_node("animation").playing = false
	queue_free()

func _on_explosion_body_entered(body):
	var distance = body.position.distance_to(position)
	var damage = 200 - distance
	if body.has_method('get_hit'):
		body.get_hit(damage)
	#print("damage vector: " + str(distance))


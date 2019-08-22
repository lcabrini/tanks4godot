extends Node2D

#var started

func start(_position):
	position = _position
	#get_node('animation').connect("finished", self, "on_explosion_done")
	get_node('animation').playing = true
	#started = true
	
	
	
#func _process(delta):
#	var a = get_node('animation')
#	if started and not a.playing:
#		queue_free()

func _on_explosion_finished():
	print("done exploding")
	get_node("animation").playing = false
	queue_free()

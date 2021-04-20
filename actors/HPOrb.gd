extends Area2D

var tick = 0.0

func _physics_process(delta):
	tick += delta
	
	if tick >= 10.0:
		queue_free()

func _on_HPOrb_body_entered(_body):
	queue_free()

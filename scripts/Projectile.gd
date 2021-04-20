extends Area2D

export(int) var duration = 3
export(int) var damage
var speed = 100

var tick = 0.0

func _physics_process(delta):
	if !GameManager.gamePaused:
		tick += delta
		
		position += transform.x * speed * delta
		
		if tick >= duration:
			queue_free()

func _on_Projectile_area_entered(_area):
	queue_free()

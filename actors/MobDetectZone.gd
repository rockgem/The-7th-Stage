extends Area2D

var playerBody = null

func _on_MobDetectZone_body_entered(body):
	playerBody = body


func canSeePlayer():
	return playerBody != null

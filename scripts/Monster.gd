extends KinematicBody2D

export(int) var hp
export(int) var damage

export(int) var moveSpeed = 40
var velocity = Vector2.ZERO

var playerBody = null

var tick = 0.0

func _physics_process(delta):
	tick += delta
	if !GameManager.gamePaused:
		if tick >= 60.0:
			queue_free()
		
		velocity = Vector2.ZERO
		
		lookForPlayer()
		
		# enemy follows player
		if playerBody != null:
			var velBetween = (playerBody.global_position - global_position).normalized()
			velocity = velocity.move_toward(velBetween, moveSpeed * delta)
			
			if velBetween.x < 0:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
		else:
			velocity = Vector2.ZERO
		
		velocity = move_and_slide(velocity * moveSpeed)

# bullet enters monster
func _on_MobHurtBox_area_entered(area):
	$AnimationPlayer.play("hurtAnim")
	hit(area.damage)

func hit(receivedDamage):
	hp -= receivedDamage
	
	if hp <= 0:
		queue_free()

func lookForPlayer():
	if playerBody == null:
		if $MobDetectZone.canSeePlayer():
			playerBody = $MobDetectZone.playerBody

#player enters player
func _on_MobHurtBox_body_entered(_body):
	queue_free()

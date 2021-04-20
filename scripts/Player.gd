extends KinematicBody2D

var hp = 100
var hpMax = 100

var velocity = Vector2.ZERO
var moveSpeed = 70

var skills = []
var skillStorage = ["Mana Burst", "Torchlight", "Gattlin Spheres", "Fire Fly", "Dart", "Cannon", "Poison Shot"]
var skillTrack = 0
var skillCurrent = 0
var skillIterate = 0

var enemySpawnTime = 2.0
var enemyHPMult = 1.0
var tick = 0.0

var stageTick = 0.0
var stageTickMax = 1.0

func _ready():
	get_tree().call_group("UIGroup", "initUI", hp, hpMax)
	var q = load("res://resources/skills/Mana Burst.tres")
	skills.append(q)
	skillCurrent = skills[0]

func _process(delta):
	if !GameManager.gamePaused:
		skillUpdate(delta)
	
	# iterates thru the available skills then sets it to currently used skill
	# does not execute when only one skill are stored
	if Input.is_action_just_pressed("ui_skill_change"):
		if skills.size() != 1:
			skillIterate += 1
			if skillIterate >= skills.size():
				skillIterate = 0
			skillCurrent = skills[skillIterate]

func _physics_process(delta):
	if !GameManager.gamePaused:
		tick += delta
		
		if tick >= enemySpawnTime:
			enemySpawner()
			tick = 0.0
		
		var vel = Vector2.ZERO
		
		vel.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vel.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		if vel.x < 0:
			$AnimatedSprite.flip_h = true
		if vel.x > 0:
			$AnimatedSprite.flip_h = false
		
		if vel != Vector2.ZERO:
			stageTick = 0.0
			velocity = vel
			$AnimatedSprite.play("run")
		else:
			stageTick += delta
			if stageTick >= stageTickMax:
				get_tree().call_group("UIGroup", "stageUpdate", 1 * delta)
			
			velocity = Vector2.ZERO
			$AnimatedSprite.play("idle")
		
		velocity = velocity.normalized()
		velocity = move_and_slide(velocity * moveSpeed)

func skillUpdate(delta):
	if skillCurrent.skillUpdate(delta):
		for x in skillCurrent.attackAmount:
			$Position2D.rotation_degrees = rand_range(0, 360)
			var proj = load("res://actors/%s.tscn" % skillCurrent.skillName)
			var newproj = proj.instance()
			
			owner.add_child(newproj)
			newproj.transform = $Position2D.global_transform
			
		$SkillSFX.play()

func enemySpawner():
	var randomEnemy = randi() % 2
	var randomShit = randi() % 4
	var randomPos = Vector2.ZERO
	match randomShit:
		# top random
		0:
			randomPos = Vector2(rand_range($Camera2D/TopLeft.global_position.x, $Camera2D/BottomRight.global_position.x), $Camera2D/TopLeft.global_position.y)
		#left random
		1:
			randomPos = Vector2($Camera2D/TopLeft.global_position.x, rand_range($Camera2D/TopLeft.global_position.y, $Camera2D/BottomRight.global_position.y))
		#bottom random
		2:
			randomPos = Vector2(rand_range($Camera2D/TopLeft.global_position.x, $Camera2D/BottomRight.global_position.x), $Camera2D/BottomRight.global_position.y)
		#default top
		_:
			randomPos = Vector2(rand_range($Camera2D/TopLeft.global_position.x, $Camera2D/BottomRight.global_position.x), $Camera2D/TopLeft.global_position.y)
	
	match randomEnemy:
		0:
			var orb = load("res://actors/HPOrb.tscn").instance()
			var enemy = load("res://actors/Mage.tscn").instance()
			enemy.global_position = randomPos
			enemy.hp *= enemyHPMult
			orb.global_position = randomPos
			owner.add_child(orb)
			owner.add_child(enemy)
		1:
			var enemy = load("res://actors/Lumot.tscn").instance()
			enemy.global_position = randomPos
			enemy.hp *= enemyHPMult
			owner.add_child(enemy)
			$MonsterSFX.play()
		_:
			var enemy = load("res://actors/Mage.tscn").instance()
			enemy.global_position = randomPos
			enemy.hp *= enemyHPMult
			owner.add_child(enemy)

# monster collided with player
func _on_PlayerDetectZone_body_entered(body):
	if hp > 0:
		hit(body.damage)

func hit(damage):
	$SFX.play()
	hp -= damage
	get_tree().call_group("UIGroup", "UIUpdate", hp)
	
	# game over when hp reaches zero
	if hp <= 0:
		GameManager.gamePaused = true
		get_tree().call_group("UIGroup", "gameOver")

func skillAdded():
	if skillTrack < skillStorage.size() - 1:
		if !enemySpawnTime <= 1.0:
			enemySpawnTime -= .3
		enemyHPMult += .3
		skillTrack += 1
#		var newWing = Sprite.new()
#		newWing.texture = load("res://images/sprites/wing%s.png" % str(skillTrack))
#		$AnimatedSprite/Wings.texture = newWing.texture
		var q = load("res://resources/skills/%s.tres" % skillStorage[skillTrack])
#		skills[skills.size()] = q
		skills.append(q)

# orb collided with player
func _on_PlayerDetectZone_area_entered(_area):
	hp += 10
	
	if hp >= 100:
		hp = hpMax
	
	get_tree().call_group("UIGroup", "UIUpdate", hp)

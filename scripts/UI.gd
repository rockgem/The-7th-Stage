extends Control

var stagePoint = 0.0
var stagePointMax = 16.6

var tick = 0.0
var sec = 0
var minute = 0

func initUI(playerHP, playerHPMax):
	$HealthBar.min_value = 1
	$HealthBar.max_value = playerHPMax
	$HealthBar.value = playerHP
	
	$Panel/StageBar.value = 0

func UIUpdate(playerHP):
	$HealthBar.value = playerHP

func _physics_process(delta):
	if !GameManager.gamePaused:
		tick += delta
		if tick >= 1.0:
			sec += 1
			$SurvivalTimeLabel.text = "%s:%s" % [minute, sec]
			tick = 0.0
		if sec >= 60.0:
			minute += 1
			$SurvivalTimeLabel.text = "%s:%s" % [minute, sec]
			sec = 0.0

func stageUpdate(delta):
	stagePoint += delta
	$Panel/StageBar.value += delta
	
	if stagePoint >= stagePointMax:
		get_tree().call_group("PlayerGroup", "skillAdded")
		stagePoint = 0.0
		$SkillAddSFX.play()
		$AnimationPlayer.play("newSkillAcquiredNotif")

func _on_HomeButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func gameOver():
	$AnimationPlayer.play("gameOverSlide")


func _on_PauseButton_pressed():
	if !GameManager.gamePaused:
		GameManager.gamePaused = true
		$PausePanel.show()
		
	else:
		GameManager.gamePaused = false
		$PausePanel.hide()


func _on_MenuButton_pressed():
	GameManager.gamePaused = true
	get_tree().change_scene("res://scenes/MainMenu.tscn")

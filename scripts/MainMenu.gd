extends Control

func _ready():
	GameManager.gamePaused = true

func _on_StartButton_pressed():
	if GameManager.gamePaused:
		GameManager.gamePaused = false
	
	get_tree().change_scene("res://scenes/World.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	$AnimationPlayer.play("settingsSlide")


func _on_BackButton_pressed():
	$AnimationPlayer.play("settingsSlideBack")


func _on_Button_pressed():
	$AnimationPlayer.play("helpSlideBack")


func _on_HelpButton_pressed():
	$AnimationPlayer.play("helpSlide")

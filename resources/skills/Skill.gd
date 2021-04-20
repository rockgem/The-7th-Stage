extends Resource
class_name Skill

export(String) var skillName
export(int) var damage
export(float) var releaseSpeed
export(int) var attackAmount

var privateTick = 0.0

func skillUpdate(receivedDelta):
	privateTick += receivedDelta
	
	if privateTick >= releaseSpeed:
		privateTick = 0.0
		return true
	
	return false

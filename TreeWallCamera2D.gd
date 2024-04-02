extends Camera2D

onready var popUp = get_parent().get_parent().get_parent().get_node("QuestPopup")

const noInput = false
# Called when the node enters the scene tree for the first time.
func _input(event):
#	if popUp.popup() == true:
#		print("popup is visible")
	if popUp.is_visible() == true:
		print("gydfygyhdafhh")
		noInput == true
		while noInput:
			pass
	else:
		pass

extends Area2D


func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		print("finna talk some smack")
		use_dialogue()

func use_dialogue():
	var dialogue = get_parent().get_node("Dialogue")
	
	if dialogue:
		dialogue.start()

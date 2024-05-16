extends Area2D


func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		use_dialogue()

func use_dialogue():
	var dialogue = get_parent().get_node("Dialogue")
	
	if dialogue:
		dialogue.start()
		dialogue.connect("dialogue_finished", self, "_on_dialogue_finished")

func _on_dialogue_finished():
	# This function is called when the dialogue ends
	# Add your code here to handle what happens after the dialogue ends
	print("wow this is amazing")
	print(get_parent().name)
	if get_parent().name == "npc":
		Global.waitingForPlayerToCompleteQuest = true
		if Global.item_names_inventory.has("Skull"):
			Global.questFINISHED = true

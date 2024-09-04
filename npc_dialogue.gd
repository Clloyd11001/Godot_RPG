extends Area2D



func _input(event):
	if event.is_action_pressed("interact") and Global.npc_area == true and len(get_overlapping_bodies()) > 0:
		use_dialogue()
	elif event.is_action_pressed("interact") and Global.npc_area == true and Global.npcName:
		use_specific_dialogue(Global.npcName)

func use_dialogue():
	var dialogue = get_parent().get_node("Dialogue")
	dialogue.start()

	
func find_node_by_name(root: Node, name: String) -> Node:
	if root.name == name:
		return root
	for child in root.get_children():
		var result = find_node_by_name(child, name)
		if result:
			return result
	return null
	
func use_specific_dialogue(npcName):
	var found_node = find_node_by_name(get_tree().root, npcName)
	var dialogue = found_node.get_node("Dialogue")
	dialogue.start()


func _on_dialogue_finished():
	# This function is called when the dialogue ends
	# Add your code here to handle what happens after the dialogue ends
	print(get_parent().name)
	if get_parent().name == "npc":
		Global.waitingForPlayerToCompleteQuest = true
		if Global.item_names_inventory.has("Skull"):
			Global.questFINISHED = true


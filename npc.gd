extends KinematicBody2D

signal dialogue_ended
signal popup_shown

var playerScene = load("res://Player/Player.tscn")

var player_instance = playerScene.instance()

const speed = 30
var current_state = IDLE
var dir = Vector2.RIGHT

var start_pos
var player
var player_in_range = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	var player_instance = playerScene.instance()
	get_parent().add_child(player_instance)
	randomize()
	start_pos = position

	# Set the initial rotation of the NPC
	rotation = 0  


func _process(delta):
	match current_state:
		IDLE:
			pass
		NEW_DIR:
			if player_in_range:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		MOVE:
			move(delta)
			
	if player_in_range and player != null:
		var angle_to_player = (global_position - player.global_position ).angle()
		global_rotation = angle_to_player + deg2rad(90)

func find_node_by_name(root: Node, name: String) -> Node:
	if root.name == name:
		return root
	for child in root.get_children():
		var result = find_node_by_name(child, name)
		if result:
			return result
	return null
	

func extract_number_from_string(text: String) -> int:
	# Length of "Chest"
	var prefix_length = 5  


	if text.length() > prefix_length:

		var number_part = text.substr(prefix_length, text.length() - prefix_length)

		if number_part.is_valid_integer():
			return int(number_part)
	
	return -1 



func move(delta):
	position += dir * speed * delta
	
	if dir.x == 1:
		$AnimatedSprite.flip_h = false
	elif dir.x == -1:
		$AnimatedSprite.flip_h = true

func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([IDLE])
	global_rotation = 0
#	emit_signal("dialogue_ended")


func get_player_node():
	var ysort_node = get_parent()
	if ysort_node == null:
		print("NPC is not a child of YSort!")
		return null
#	print("ysort tree", ysort_node.get_children())
#	var player_node = ysort_node.get_node("Player")
#	if player_node == null:
#		return null
	
#	return player_node

func set_rotation_based_on_direction(direction: Vector2):
	if direction == Vector2.RIGHT:
		rotation = 0
	elif direction == Vector2.UP:
		rotation = deg2rad(-90)
	elif direction == Vector2.LEFT:
		rotation = deg2rad(180)
	elif direction == Vector2.DOWN:
		rotation = deg2rad(90)

func _on_Area2D_body_shape_entered(body):
	if body.name == 'Player':
		Global.npc_area = true
		var npcName = $".".to_string()
		var extractedNPC = extract_node_names(npcName)
		Global.npcName = extractedNPC[0]
		var found_node = find_node_by_name(get_tree().root, extractedNPC[0])
		if body:
			player_in_range = true

func _on_Area2D_body_entered(body):

	if body.name == 'Player':
		Global.npc_area = true
		var npcName = $".".to_string()
		var extractedNPC = extract_node_names(npcName)
		Global.npcName = extractedNPC[0]
		var found_node = find_node_by_name(get_tree().root, extractedNPC[0])
		if body:
			player_in_range = true


func _on_Area2D_area_exited(area):
	print("1st NPC's area 2D exited")


func _on_Area2D_area_entered(area):
	print("AHHHH I THINK IM GETTING THE HANG OF THIS")


func _on_Area2D_body_exited(body):
	Global.npc_area = false
	
	if body:
		player_in_range = false

func extract_node_names(message: String) -> Array:
	var names: Array = []
	
	# Split the message into lines
	var lines = message.split("\n")
	
	for line in lines:
		# Find the index of the ':' character
		var colon_index = line.find(":")
		
		if colon_index != -1:
			# Extract the node name from the beginning to the ':' character
			var node_name = line.substr(0, colon_index).strip_edges()
			names.append(node_name)
	
	return names
	
#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("interact") and player_in_range:
#		var chestName = $".".to_string()
#		var extractedNPC = extract_node_names(chestName)
#		var found_node = find_node_by_name(get_tree().root, Global.npcName)
#		print('found_node',found_node)
#		print('extractedNPC',extractedNPC)
#		print('chestName',chestName)



func _on_Dialogue_dialogue_finished():
	print("NAME OF PARENT", $".".name)
	if $".".name == "fairy":
		print("PlayerInventory")
		# EVERY TIME YOU ADD TO PLAYER INVENTOYR HAVE TO CHANGE ITEMDATA.JSON TO CONTAIN APPROPRIATE ITEM
		# need a popup right here
		
		var panel = player_instance.get_node("Panel")
		var label = panel.get_node("Label")

		# Set label text
		label.text = "PixieDust has been added to the inventory"
		emit_signal("popup_shown")
		
		PlayerInventory.add_item('PixieDust', 1, 'Green dust released by a mysterious fairy')
		
		print("Global.inventoryItemInfo", Global.inventoryItemInfo)
		print("PlayerInventory", PlayerInventory)
		if Global.item_names_inventory.has("PixieDust"):
			print("IM ACTUALLY A MONKEYS UNCLE, IM ACTUALLY A MONKEYS UNCLE, IM ACTUALLY A MONKEYS UNCLE")
		


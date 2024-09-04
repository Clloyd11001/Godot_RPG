extends CanvasLayer

# Access our JSON file
export(String, FILE, "*.json") var dialogue_file

# Hold the name and text
var dialogue = []
export(int) var current_dialogue_id = 0
var dialogue_active = false
signal dialogue_started
signal dialogue_finished

onready var tutorial_started = true
onready var fontSize = get_node("NinePatchRect/Chat")
onready var fontSizeName = get_node("NinePatchRect/Name")
onready var npc = get_parent()

var player_in_range

var talkedToNPCSecondTime

func _ready():
	npc.connect("dialogue_ended", self, "_on_npc_dialogue_ended")

	$NinePatchRect.visible = false
	var fontSizeNumber = fontSize.get_font("font")
	var fontSizeNameNumber = fontSizeName.get_font("font")
	fontSizeNumber.size = 9
	fontSizeNameNumber.size = 9


func start():
	if dialogue_active:
		return
	dialogue_active = true
	$NinePatchRect.visible = true
	
	emit_signal("dialogue_started")
	
	# Get the parent node (assuming the parent is the NPC sprite)
	var npc_sprite = get_parent()

	# Extract the NPC name from the parent's name
	var npc_name = npc_sprite.get_name()
	
	# Define the default dialogue file path
	dialogue_file = "res://dialogues/json/" + Global.npcName + ".json"
	print("dialogue_file", dialogue_file)
	# Check if we need to load an alternate dialogue file

	if Global.waitingForPlayerToCompleteQuest and !talkedToNPCSecondTime:
		dialogue_file = "res://dialogues/json/" + npc_name + '1' + ".json"
		talkedToNPCSecondTime = true
	
	elif talkedToNPCSecondTime:
		dialogue_file = "res://dialogues/json/" + npc_name + '2' + ".json"
		print(PlayerInventory.Inventory)
		if Global.has_item("Brain"):
			print("NOW ITS TIME TO GIVE YOU YOUR REWARDS, LETS START ")
			var ribcage_json = {
				"name": "Ribcage",
				"description": "a broken rib",
				"quantity": "1"
			}
			PlayerInventory.Inventory.append(ribcage_json)

	# Load the dialogue from the chosen file
	dialogue = load_dialogue(dialogue_file)
	current_dialogue_id = -1
	
	next_script()


# DO NOT PUT AN UNDERSCORE BEFORE DIALOGUE_FILE
func load_dialogue(my_file):
	var file = File.new()
	if file.file_exists(my_file):
		file.open(my_file, file.READ)
		return parse_json(file.get_as_text())
	else:
		print("Error: Dialogue file not found -", my_file)
		return []
		
func _input(event):
	if not dialogue_active:
		return
	
	if current_dialogue_id == 2 and dialogue_file == "res://dialogues/json/elder.json":
		# Check for specific input
		if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			tutorial_started = true
			next_script()
		return

	if current_dialogue_id == 4 and dialogue_file == "res://dialogues/json/elder.json":
		# Check for specific input
		if Input.is_action_just_pressed("attack"):
			tutorial_started = true
			next_script()
		return

	if current_dialogue_id == 6 and dialogue_file == "res://dialogues/json/elder.json":
		# Check for specific input
		if Input.is_action_just_pressed("roll"):
			tutorial_started = true
			next_script()
		return

	# Default behavior for other dialogue lines
	if event.is_action_pressed("ui_accept"):
		tutorial_started = false
		yield(get_tree().create_timer(0.1), "timeout")  # Introduce a small delay
		tutorial_started = true
		next_script()
				
func next_script():
	if tutorial_started == true:
		current_dialogue_id += 1
	else:
		return

	if current_dialogue_id >= len(dialogue):
		$Timer.start()
		dialogue_active = false
		$NinePatchRect.visible = false
		return

	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Chat.text = dialogue[current_dialogue_id]['text']

func _on_Timer_timeout():
	dialogue_active = false
	emit_signal("dialogue_finished")
	
	QuestSystem.addQuest("MQ001")
	QuestSystem.advanceQuest("MQ001")

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

func find_node_by_name(root: Node, name: String) -> Node:
	if root.name == name:
		return root
	for child in root.get_children():
		var result = find_node_by_name(child, name)
		if result:
			return result
	return null

func _on_Area2D_body_entered(body):

	var npcName = $".".to_string()
	print("entered", npc.name)
	Global.npcName = npc.name
	var extractedNPC = extract_node_names(npc.name)
	print('extractedNPC', extractedNPC)
	var found_node = find_node_by_name(get_tree().root, Global.npcName)
	Global.npcNode = found_node
	print('found_node',found_node)
	print('extractedNPC',extractedNPC)
	print('npcName',npcName)
	if body:
		player_in_range = true
	Global.npc_area = true

func _on_Area2D_body_exited(body):
	print("we getting in here?!????????????????????????????????!?!?!!!!!!!!!!!!")
	Global.npc_area = false


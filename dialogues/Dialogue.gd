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
var talkedToNPCSecondTime

func _ready():
	$NinePatchRect.visible = false

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
	dialogue_file = "res://dialogues/json/" + npc_name + ".json"
	
	# Check if we need to load an alternate dialogue file
	print(Global.waitingForPlayerToCompleteQuest)
	print(talkedToNPCSecondTime)
	if Global.waitingForPlayerToCompleteQuest and !talkedToNPCSecondTime:
		dialogue_file = "res://dialogues/json/" + npc_name + '1' + ".json"
		print("is this true", Global.questFINISHED)
		talkedToNPCSecondTime = true
	elif talkedToNPCSecondTime:
		print("SO WE ARE GETTING HERE!!!!!")
		dialogue_file = "res://dialogues/json/" + npc_name + '2' + ".json"
		print("NOW ITS TIME TO GIVE YOU YOUR REWARDS, LETS START ON (5/17)")
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
	

extends CanvasLayer

# Access our JSON file
export(String, FILE, "*.json") var dialogue_file

# Hold the name and text
var dialogue = []
export(int) var current_dialogue_id = 0
var dialogue_active = false
signal dialogue_started
signal dialogue_finished

onready var tutorial_started = false

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
	
	print(npc_name)
	
	dialogue_file = "res://dialogues/json/" + npc_name + ".json"
	
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
	if event.is_action_pressed("ui_accept"):
		tutorial_started = true
		yield(get_tree().create_timer(0.1), "timeout")  # Introduce a small delay
		tutorial_started = false
		next_script()

	if current_dialogue_id == 2 and dialogue_file == "res://dialogues/json/elder.json":

		tutorial_started = true
		if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_up"):
			tutorial_started = false



			next_script()
			
	if current_dialogue_id == 4 and dialogue_file == "res://dialogues/json/elder.json":
		tutorial_started = true

		if Input.is_action_just_released("attack") or Input.is_action_just_released("attack") or Input.is_action_just_released("attack") or Input.is_action_just_released("attack"):

			tutorial_started = false
			next_script()
		
	if current_dialogue_id == 6 and dialogue_file == "res://dialogues/json/elder.json":
			tutorial_started = true

			if Input.is_action_pressed("roll") or Input.is_action_just_released("roll") or Input.is_action_just_pressed("roll"):

				tutorial_started = false
				next_script()
				
func next_script():

	
	if tutorial_started == false:

		current_dialogue_id += 1
		print(current_dialogue_id)
	
	
			
	
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
	#
	QuestSystem.advanceQuest("MQ001")
	

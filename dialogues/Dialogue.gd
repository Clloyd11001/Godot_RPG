extends CanvasLayer

# Access our JSON file
export(String, FILE, "*.json") var dialogue_file

# Hold the name and text
var dialogue = []
var current_dialogue_id = 0
var dialogue_active = false
signal dialogue_started
signal dialogue_finished

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
	
	var dialogue_file = "res://dialogues/json/" + npc_name + ".json"
	
	dialogue = load_dialogue(dialogue_file)
	current_dialogue_id = -1
	next_script()
	
func load_dialogue(dialogue_file: String):
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
	else:
		print("Error: Dialogue file not found -", dialogue_file)
		return []
		
func _input(event):
	if not dialogue_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func next_script():
	current_dialogue_id += 1
	

	if current_dialogue_id >= len(dialogue):
		$Timer.start()
		dialogue_active = false
		$NinePatchRect.visible = false
		
		#$Timer.wait_time = 2.0
		#$Timer.start()
		return
		
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Chat.text = dialogue[current_dialogue_id]['text']


func _on_Timer_timeout():
	dialogue_active = false
	emit_signal("dialogue_finished")
#func _on_Area2D_body_entered(body):
#	print("etnered body")
#
#	start()

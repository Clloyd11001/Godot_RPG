extends CanvasLayer

# Access our JSON file
export(String, FILE, "*.json") var dialogue_file

# Hold the name and text
var dialogue = []
var current_dialogue_id = 0
var dialogue_active = false

func _ready():
	$NinePatchRect.visible = false
	#start()

func start():
	if dialogue_active:
		return
	dialogue_active = true
	$NinePatchRect.visible = true
	
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()
	
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())

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

#func _on_Area2D_body_entered(body):
#	print("etnered body")
#
#	start()

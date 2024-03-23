extends Node



const JsonParser = preload("res://dialogues/Dialogue.gd")

onready var playerExperience = $YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var elderDialogue = $elder/Dialogue
onready var popUp = get_node("Control/TextureRect")
onready var popUpText = get_node("Control/Label")
onready var loading = get_node("/root/Loading")
onready var timer = get_node("Timer")
onready var dialogue_file = "res://dialogues/json/elder.json" 
onready var player = get_node("YSort/Player")

var file = File.new()



var level1_scene_path = "res://Level1.tscn"  
var json_string = JSON.print(dialogue_file)


# Called when the node enters the scene tree for the first time.
func _ready():



	playerExperience.visible = false
	#questNotification.visible = false
	elderDialogue.connect("dialogue_finished", self, "_on_dialogue_finished")


	#tryinh to get specific line in json
	var load_dialogue_instance = JsonParser.new()

	
	var loaded_dialogue = load_dialogue_instance.load_dialogue(dialogue_file)

	for currentLine in loaded_dialogue.size():
		if loaded_dialogue:
				# Check if there are at least 4 lines in the dialogue
				if loaded_dialogue.size() >= 3:
					pass
					# Print the third line (index 2 since indexing starts from 0)
					#print("Lines:", loaded_dialogue[currentLine])

				else:
					print("The dialogue file does not have at least 3 lines.")
		

	
func _on_dialogue_finished():
	# Did not figure out popups lol, just did it with a textureRect
	start_timer()




func start_timer():
	timer.wait_time = 4 
	# sends only once
	timer.one_shot = true  

	popUp.visible = true
	popUpText.visible = true
	timer.start()  
	


func _on_Timer_timeout():

	var _lvl1SceneChange = get_tree().change_scene(level1_scene_path)
	loading.load_scene(self, level1_scene_path)
	QuestSystem.addQuest("MQ001")
	QuestSystem.advanceQuest("MQ001")
	
	var trigger = load("res://LocationTrigger.tscn")
	var ti = trigger.instance()
	ti.QuestID = "MQ001"	

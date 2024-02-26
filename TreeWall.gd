extends Node

signal player_completed_attack_tutorial

const JsonParser = preload("res://dialogues/Dialogue.gd")

onready var playerExperience = $YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var elderDialogue = $elder/Dialogue
#onready var questNotification = $YSort/Player/QuestNotificationPanel
onready var popUp = $PopupPanel
onready var loading = get_node("/root/Loading")

var file = File.new()
onready var dialogue_file = "res://dialogues/json/elder.json" 


var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly
var json_string = JSON.print(dialogue_file)
var currentLine = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	playerExperience.visible = false
	#questNotification.visible = false
	elderDialogue.connect("dialogue_finished", self, "_on_dialogue_finished")


	#tryinh to get specific line in json
	var load_dialogue_instance = JsonParser.new()
	
	#print(JsonParser.current_dialogue_id)
	
	var loaded_dialogue = load_dialogue_instance.load_dialogue(dialogue_file)

	for currentLine in loaded_dialogue.size():
		if loaded_dialogue:
				# Check if there are at least 3 lines in the dialogue
				if loaded_dialogue.size() >= 3:
					
					# Print the third line (index 2 since indexing starts from 0)
					print("Lines:", loaded_dialogue[currentLine])
					# Work on this logic morer	
					if currentLine == 3:
						yield(self, "player_completed_attack_tutorial")
						
					# Now right here, i need to wait if its at specific current line for the input	
							
				else:
					print("The dialogue file does not have at least 3 lines.")
		

		
func _on_dialogue_finished():
	# Put a stick in this for now, trying to figure out popups
	#popUp.show()
	
	var _lvl1SceneChange = get_tree().change_scene(level1_scene_path)
	loading.load_scene(self, level1_scene_path)
	QuestSystem.addQuest("MQ001")
	QuestSystem.advanceQuest("MQ001")
	var trigger = load("res://LocationTrigger.tscn")
	var ti = trigger.instance()
	ti.QuestID = "MQ001"	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		currentLine += 1
	if event.is_action_pressed("attack") and currentLine ==  3:
		emit_signal("player_completed_attack_tutorial")

func _on_player_completed_attack_tutorial():
	currentLine += 1
	

extends Node

const JsonParser = preload("res://dialogues/Dialogue.gd")

onready var playerExperience = $YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var elderDialogue = $elder/Dialogue
onready var questNotification = $YSort/Player/QuestNotificationPanel
onready var popUp = $PopupPanel

var file = File.new()
onready var dialogue_file = "res://dialogues/json/elder.json" 

var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly
var json_string = JSON.print(dialogue_file)


# Called when the node enters the scene tree for the first time.
func _ready():
	playerExperience.visible = false
	#questNotification.visible = false
	elderDialogue.connect("dialogue_finished", self, "_on_dialogue_finished")


	#tryinh to get specific line in json
	var load_dialogue_instance = JsonParser.new()
	
	var loaded_dialogue = load_dialogue_instance.load_dialogue(dialogue_file)
	
	if loaded_dialogue:
			# Check if there are at least 3 lines in the dialogue
			if loaded_dialogue.size() >= 3:
				# Print the third line (index 2 since indexing starts from 0)
				print("Third line:", loaded_dialogue[2])
			else:
				print("The dialogue file does not have at least 3 lines.")
		

		
func _on_dialogue_finished():
	# Put a stick in this for now, trying to figure out popups
	#popUp.show()
	
	get_tree().change_scene(level1_scene_path)
	QuestSystem.addQuest("MQ001")
	QuestSystem.advanceQuest("MQ001")
	var trigger = load("res://LocationTrigger.tscn")
	var ti = trigger.instance()
	ti.QuestID = "MQ001"	

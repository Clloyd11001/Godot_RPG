extends Node

onready var playerExperience = $YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var elderDialogue = $elder/Dialogue
onready var questNotification = $YSort/Player/QuestNotificationPanel
onready var popUp = $PopupPanel


var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly

# Called when the node enters the scene tree for the first time.
func _ready():
	playerExperience.visible = false
	#questNotification.visible = false
	elderDialogue.connect("dialogue_finished", self, "_on_dialogue_finished")

func _on_dialogue_finished():
	# Put a stick in this for now, trying to figure out popups
	#popUp.show()
	
	get_tree().change_scene(level1_scene_path)
	QuestSystem.addQuest("MQ001")
	QuestSystem.advanceQuest("MQ001")
	var trigger = load("res://LocationTrigger.tscn")
	var ti = trigger.instance()
	ti.QuestID = "MQ001"	

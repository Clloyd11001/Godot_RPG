extends Node

onready var playerExperience = $YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var elderDialogue = $elder/Dialogue
var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly

# Called when the node enters the scene tree for the first time.
func _ready():
	playerExperience.visible = false
	elderDialogue.connect("dialogue_finished", self, "_on_dialogue_finished")

func _on_dialogue_finished():
	get_tree().change_scene(level1_scene_path)

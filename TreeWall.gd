extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var playerExperience = $YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var elderDialogue = $elder/Dialogue
# Called when the node enters the scene tree for the first time.
func _ready():
	playerExperience.visible = false
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Control

onready var player = $Player
onready var playerExperience = $Player/CanvasLayer/MarginContainer/ExperienceInterface
# Called when the node enters the scene tree for the first time.
func _ready():
	player.visible = false
	playerExperience.visible = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var _respawn = get_tree().change_scene("res://Level1.tscn")
		

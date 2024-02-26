extends Control

onready var player = $Player
onready var playerExperience = $Player/CanvasLayer/MarginContainer/ExperienceInterface
onready var background
onready var label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.visible = false
	playerExperience.visible = false
	label.set_size(get_viewport_rect().size, true) 

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var _respawn = get_tree().change_scene("res://Level1.tscn")
		

extends Node2D

onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.

# update_text used to have _character.level as a param
func _ready():
	_label.update_text( _character.experience, _character.experience_required)
	
# Getting enemy death to trigger character exp gain
	enemy.connect("enemy_defeated", self, "_on_EnemyDefeated")
	# should create the experience bar?
	_bar.initialize(_character.experience, _character.experience_required)

# update_text used to have _character.level as a param
func _on_EnemyDefeated():
	_character.gain_experience(34)
	_label.update_text( _character.experience, _character.experience_required)
	

	
	



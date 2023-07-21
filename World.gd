extends Node2D

onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")
onready var textBox = get_node("Textbox")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.

var house = null setget set_house
# update_text used to have _character.level as a param
func _ready():
	set_house(null)
	_label.update_text( _character.experience, _character.experience_required)
	
# Getting enemy death to trigger character exp gain
	enemy.connect("enemy_defeated", self, "_on_EnemyDefeated")
	# should create the experience bar?
	_bar.initialize(_character.experience, _character.experience_required)

func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("interact") and house != null:
		#Global.player_outside_pos = global_position
		house.enter()
		
# update_text used to have _character.level as a param
func _on_EnemyDefeated():
	_character.gain_experience(34)
	_label.update_text( _character.experience, _character.experience_required)
	

func set_house(new_house):
	if new_house != null:
		textBox.queue_text("Press I to open door!")
		#$KeyPrompt.show()
	else:
		textBox.hide_textbox()

	house = new_house
	
	

func _on_DoorWay_body_entered(body):
	textBox.queue_text("Press I to open door!")
	print("WE CAN SEE THE HOUSE")

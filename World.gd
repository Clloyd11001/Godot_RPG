extends Node2D

onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")
onready var textBox = get_node("Textbox")


# update_text used to have _character.level as a param
func _ready():
	$YSort/Player.global_position = Global.player_pos
	_label.update_text( _character.experience, _character.experience_required)
	
# Getting enemy death to trigger character exp gain
	enemy.connect("enemy_defeated", self, "_on_EnemyDefeated")
	# should create the experience bar?
	_bar.initialize(_character.experience, _character.experience_required)

#func _unhandled_input(event):
#	if event is InputEventKey and event.is_action_pressed("interact") and house != null:
#		#Global.player_outside_pos = global_position
#		house.enter()
#		textBox.hide_textbox()
		
# update_text used to have _character.level as a param
func _on_EnemyDefeated():
	_character.gain_experience(34)
	_label.update_text( _character.experience, _character.experience_required)


	
func _on_DoorWay_body_entered(body):
	# How to call textbox from different scene?
	print("")
	#textBox.hide()
	#Only shows once, should happen every time
	textBox.queue_text("Press I")
	#textBox.display_text()
	#print("we here")

func _on_DoorWay_body_exited(body):
	textBox.hide_textbox()
	

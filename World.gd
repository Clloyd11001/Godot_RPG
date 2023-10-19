extends Node2D



onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")
onready var textBox = get_node("Textbox")


enum {
	OUTSIDE,
	INSIDE,
	UNDERGROUND
}

var location = OUTSIDE

# update_text used to have _character.level as a param
func _ready():
	# Putting this line of code makes character spawn in specific location
	#$YSort/Player.global_position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
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
		
	#Only shows once, should happen every time
	textBox.queue_text("Press I to enter the house")
	if Input.is_action_just_pressed("interact"):
		location = INSIDE
		set_camera_limits()
		

func _on_DoorWay_body_exited(body):
	textBox.hide_textbox()
#
func set_camera_limits():
	if location == INSIDE:
		var map_limits = $TileMap.get_used_rect()
		var map_cellsize = $TileMap.cell_size
		$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
		$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
		$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
		$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

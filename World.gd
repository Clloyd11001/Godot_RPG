extends Node2D



onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")
onready var textBox = get_node("Textbox")
onready var hearts = get_node("CanvasLayer/HealthUI")
#onready var questMenu = get_node("YSort/Player/QuestNotificationPanel")
const gameOverScene = preload("res://GameOver.tscn")

enum {
	OUTSIDE,
	INSIDE,
	UNDERGROUND
}

var location = OUTSIDE

# Somewhere in my ready, its showing the questManager, look right here

# update_text used to have _character.level as a param
func _ready():
	# Putting this line of code makes character spawn in specific location
	#$YSort/Player.global_position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
	_label.update_text( _character.experience, _character.experience_required)
	
# Getting enemy death to trigger character exp gain
	enemy.connect("enemy_defeated", self, "_on_EnemyDefeated")
	# should initialize the experience bar
	_bar.initialize(_character.experience, _character.experience_required)
#	if questMenu != null:
#		print("CAN I TEST PLEASE")
#		print(questMenu)
#		questMenu.visible = false
	if get_tree().current_scene == gameOverScene:
		hearts.visible = false

# update_text used to have _character.level as a param
func _on_EnemyDefeated():
	print("killed enemy")
	_character.gain_experience(50)
	_label.update_text( _character.experience, _character.experience_required)


	
func _on_DoorWay_body_entered(_body):
		
	#Only shows once, should happen every time
	textBox.queue_text("Press I to enter the house")
	if Input.is_action_just_pressed("interact"):
		location = INSIDE
		set_camera_limits()
		

func _on_DoorWay_body_exited(_body):
	textBox.hide_textbox()
	
# need to set limits for camera when game over happens
func set_camera_limits():
	if location == INSIDE:
		var map_limits = $TileMap.get_used_rect()
		var map_cellsize = $TileMap.cell_size
		$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
		$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
		$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
		$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y


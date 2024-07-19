extends Node2D



onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")
onready var textBox = get_node("Textbox")
onready var hearts = get_node("CanvasLayer/HealthUI")
onready var inventory_layer = get_node("YSort/Player/UserInterface/Inventory")
onready var locationTrigger = get_node("LocationTrigger")
const gameOverScene = preload("res://GameOver.tscn")
#onready var questNotification = get_node("YSort/Player/QuestNotificationPanel")

enum {
	OUTSIDE,
	INSIDE,
	UNDERGROUND
}

var location = OUTSIDE

# Somewhere in my ready, its showing the questManager, look right here

# update_text used to have _character.level as a param
func _ready():
	Global.COMBOS = true
	Global.QUESTS = true
	Global.FIRSTQUEST = true
	
	_label.update_text( PlayerStats.level,_character.experience, _character.experience_required)
	
# Getting enemy death to trigger character exp gain
	enemy.connect("enemy_defeated", self, "_on_enemy_defeated")
	# should initialize the experience bar
	_bar.initialize(_character.experience, _character.experience_required)

	if get_tree().current_scene == gameOverScene:
		hearts.visible = false
	
	Global.firstQuestPosition = locationTrigger.global_position 
# update_text used to have _character.level as a param
func _on_enemy_defeated():
	print("killed enemy")
	_character.gain_experience(50)
	_label.update_text( PlayerStats.level,_character.experience, _character.experience_required)


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


func _on_Area2D_body_entered(body):
	print("entering into the portal")

extends Node2D



onready var _character = get_node("YSort/Player")
onready var label = get_tree()
onready var _label = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/Label")
onready var _bar = get_node("YSort/Player/CanvasLayer/MarginContainer/ExperienceInterface/ExperienceBar")
onready var enemy = get_node("YSort/Bat")
onready var textBox = get_node("Textbox")
onready var hearts = get_node("CanvasLayer/HealthUI")
onready var inventory_layer = get_node("YSort/Player/UserInterface/Inventory")
#onready var questMenu = get_node("YSort/Player/QuestNotificationPanel")
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
	_label.update_text( _character.experience, _character.experience_required)
	
# Getting enemy death to trigger character exp gain
	enemy.connect("enemy_defeated", self, "_on_EnemyDefeated")
	# should initialize the experience bar
	_bar.initialize(_character.experience, _character.experience_required)

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


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
 if response_code == 200:
		print("HTTP request successful!")
		var parsedBody = parse_json(body.get_string_from_utf8())
		print("Parsed JSON:", parsedBody)
		
		if parsedBody != null:
			if parsedBody.has("item_data"):
				var item_data = parsedBody["item_data"]
				for item_name in item_data.keys():
					var stack_size = 1  # Default stack size
					if item_data[item_name].has("StackSize"):
						stack_size = item_data[item_name]["StackSize"]
					PlayerInventory.add_item(item_name, stack_size)
				print("Received inventory data:", parsedBody)
			elif parsedBody.has("items"):
				var items = parsedBody["items"]
				for item in items:
					var item_name = item["Name"]
					var stack_size = item["StackSize"]
					var description = item["Description"]
					PlayerInventory.add_item(item_name, stack_size)
				print("Received inventory data:", parsedBody)
			else:
				print("Parsed JSON does not contain item_data or items!")
		else:
			print("Parsed JSON is null!")
	else:
		print("HTTP request failed:", response_code)

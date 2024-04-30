extends Node

var player_pos : Vector2

var COMBOS = true
var QUESTS = true
# Stack to keep track of scene history
var scene_stack = []
var currentScene

const firstScene = "res://Level1.tscn"

func _ready():
	if Global.currentScene == 'TreeWall':
		Global.COMBOS = false
		Global.QUESTS = false
		
	if Global.currentScene == "Level1":
		Global.COMBOS = true
		Global.QUESTS = true

func update_scene(scene_to_be_changed_to):
	currentScene = scene_to_be_changed_to

# Load a scene and push it onto the stack
func switch_to_scene(scene_path):
	var scene = ResourceLoader.load(scene_path)
	if scene:
		scene_stack.append(scene)
		#print(scene_stack)
		get_tree().change_scene(scene_path)

# Switch to the previous scene
func switch_to_previous_scene():
	if scene_stack.size() > 1:
		var previous_scene = firstScene # Get the previous scene
	
		get_tree().change_scene(previous_scene)
	else:
		print("No previous scene to switch to.")

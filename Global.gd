extends Node

var player_pos : Vector2


# Stack to keep track of scene history
var scene_stack = []



# Load a scene and push it onto the stack
func switch_to_scene(scene_path):
	var scene = ResourceLoader.load(scene_path)
	if scene:
		scene_stack.append(scene)
		get_tree().change_scene(scene_path)

# Switch to the previous scene
func switch_to_previous_scene():
	if scene_stack.size() > 1:
		scene_stack.pop_back() # Remove the current scene
		var previous_scene = scene_stack.pop_back() # Get the previous scene
		get_tree().change_scene(previous_scene)
	else:
		print("No previous scene to switch to.")

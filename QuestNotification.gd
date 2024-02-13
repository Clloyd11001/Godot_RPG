extends Panel

var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("Quests"):
		Global.switch_to_scene(level1_scene_path)

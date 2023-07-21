extends Sprite

export (PackedScene) var inside_scene

var house = 0

func _on_DoorWay_body_entered(body):
	house = 1
	#print("NEAR ME")


func _on_DoorWay_body_exited(body):
	if house == 1:
		house == 0

func enter():
	get_tree().change_scene(inside_scene.resource_path)

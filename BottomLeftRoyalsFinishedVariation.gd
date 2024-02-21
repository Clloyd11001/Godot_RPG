extends Sprite

export (PackedScene) var inside_scene

var exit_position = Vector2(1013, 76) # Set the default exit position here


func _on_DoorWay_body_entered(body):
	body.house = self
	var _buildingName = get_name()
	LocationManager.setBuildingLocation("Inside2", exit_position)
	#body.position = exit_position

func _on_DoorWay_body_exited(body):
	if body.house == self:
		body.house = null

func enter():
	var _goInsideSceneChange = get_tree().change_scene(inside_scene.resource_path)

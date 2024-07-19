extends Sprite

export (PackedScene) var inside_scene




func _on_DoorWay_body_entered(body):
	body.house = self
	var buildingName = get_name()
	var exitPos = LocationManager.getBuildingLocation(buildingName)
	LocationManager.setBuildingLocation("Inside2", exitPos)
	#body.position = exit_position

func _on_DoorWay_body_exited(body):
	if body.house == self:
		body.house = null

func enter():
	var _goInsideSceneChange = get_tree().change_scene(inside_scene.resource_path)

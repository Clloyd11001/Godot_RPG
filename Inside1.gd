extends Node2D

var entered = false


onready var player = get_node("res://Player/Player.tscn")
#onready var test = get_parent()
var exit_position = Vector2(1013, 76) # Set the default exit position here


var outside = "res://Level1.tscn" 


func _on_Exit_body_entered(body):
	if entered:
		print("Body entered:", body)
		if body:
			print("Body name:", body.get_name())
#			print("Body type:", body.get_type())
		else:
			print("Body is null")
		
		get_tree().change_scene(outside)
		if body:
			var buildingName = get_name()
			var exitPos = LocationManager.getBuildingLocation(buildingName)
			if exitPos:
				body.position = exitPos
			else:
				print("Exit position for", buildingName, "not found")
		else:
			print("Cannot set position because body is null")

		
func _on_Exit_body_exited(body):
	entered = true

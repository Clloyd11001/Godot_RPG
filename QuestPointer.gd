extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("nothing")


func lookTowardsObject(target_position: Vector2):
	var angle_to_player = (global_position - target_position).angle()
	# Update the node's rotation to point towards the target position
	global_rotation = angle_to_player 
	
		# Flip the arrow sprite based on the angle
	if angle_to_player > -PI/2 && angle_to_player < PI/2:
		global_rotation += PI
	else:
		global_rotation -= PI
	

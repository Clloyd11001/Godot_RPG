extends KinematicBody2D

signal dialogue_ended

const speed = 30
var current_state = IDLE
var dir = Vector2.RIGHT

var start_pos
var player
var player_in_range = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position

	# Set the initial rotation of the NPC
	rotation = 0  


func _process(delta):
	match current_state:
		IDLE:
			pass
		NEW_DIR:
			if player_in_range:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				# Instantly jump to the new direction
		MOVE:
			move(delta)
			
	if player_in_range and player != null:
		var angle_to_player = (global_position - player.global_position ).angle()
		global_rotation = angle_to_player + deg2rad(90)


func move(delta):
	position += dir * speed * delta
	
	if dir.x == 1:
		$AnimatedSprite.flip_h = false
	elif dir.x == -1:
		$AnimatedSprite.flip_h = true

func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([IDLE])
	global_rotation = 0
#	emit_signal("dialogue_ended")


func get_player_node():
	var ysort_node = get_parent()
	if ysort_node == null:
		print("NPC is not a child of YSort!")
		return null
#	print("ysort tree", ysort_node.get_children())
#	var player_node = ysort_node.get_node("Player")
#	if player_node == null:
#		return null
	
#	return player_node

func set_rotation_based_on_direction(direction: Vector2):
	if direction == Vector2.RIGHT:
		rotation = 0
	elif direction == Vector2.UP:
		rotation = deg2rad(-90)
	elif direction == Vector2.LEFT:
		rotation = deg2rad(180)
	elif direction == Vector2.DOWN:
		rotation = deg2rad(90)





func _on_Area2D_body_entered(body):
	print("YOOOO")
	if body:
		player_in_range = true



func _on_Area2D_area_exited(area):
	print("AYYYYY")


func _on_Area2D_area_entered(area):
	print("AHHHH I THINK IM GETTING THE HANG OF THIS")


func _on_Area2D_body_exited(body):
	print("UMMMMMM")

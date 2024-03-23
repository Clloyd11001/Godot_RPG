extends Node2D

var combo_list = {
	"lp_lp_hk_combo" : ["light_punch", "light_punch", "heavy_kick"],
	"uppercut": ["attack", "dir_right","attack"],
	"light_fireball_right": ["dir_down", "dir_down_right", "dir_right", "light_punch"]
	}

const directions = [
	"left",
	"up_left",
	"up",
	"up_right",
	"right",
	"down_right",
	"down",
	"down_left"
]

var current_dir_action = "idle"
var last_tick_dir_action = ""
var action_buffer = []
var max_actions_in_buffer = 5



#onready var player = get_node("Player/AnimatedSprite")


func _physics_process(delta):
#	player.play("combo")
	#add_child(clear_buffer_timer)
	var dir_input = Vector2.ZERO
	dir_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if dir_input == Vector2.ZERO:
		current_dir_action = "idle"
	else:
		var direction_id = int(8.0 * (dir_input.rotated(PI / 8.0).angle() + PI) / TAU)
		current_dir_action = str("dir_", directions[direction_id])
	
	if last_tick_dir_action != current_dir_action and current_dir_action != "idle":
		action_buffer.append(current_dir_action)
		compare_buffer_with_combo_list()
	last_tick_dir_action = current_dir_action
	
	if Input.is_action_just_pressed("attack"):
		print("just appended attack")
		action_buffer.append("attack")
		compare_buffer_with_combo_list()
#	elif Input.is_action_just_pressed("heavy_punch"):
#		action_buffer.append("heavy_punch")
#		compare_buffer_with_combo_list()
#	elif Input.is_action_just_pressed("light_kick"):
#		action_buffer.append("light_kick")
#		compare_buffer_with_combo_list()
#	elif Input.is_action_just_pressed("heavy_kick"):
#		action_buffer.append("heavy_kick")
#		compare_buffer_with_combo_list()
func print_node_tree(node, depth=0):
	# Print the node name with indentation based on depth
	print("\t".repeat(depth) + node.name)

	
	# Recursively print children
	for i in range(node.get_child_count()):
		print_node_tree(node.get_child(i), depth + 1)


func compare_buffer_with_combo_list():
	

	if action_buffer.size() > max_actions_in_buffer:
		action_buffer.pop_front()
	print(action_buffer)
	var all_combo_moves = combo_list.values()
	var all_combo_move_names = combo_list.keys()
	for i in all_combo_moves.size():
		if all_combo_moves[i] == action_buffer:
			print(all_combo_move_names[i])
			return true
		#put in the player.gd
#			player.visible = true
#			player.play("combo")
#			player.visible = false

func _on_Timer_timeout():
	print("anything!")
	action_buffer = []
	print("Buffer cleared!")

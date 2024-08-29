extends AnimatedSprite

export(PackedScene) var object_scene: PackedScene = preload("res://Items/Transperent/RubyDrop.tscn")


var randomId: int
var is_player_inside: bool = false
var is_opened: bool = false
var chestIndex

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tween:Tween = get_node("Tween")

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize() 
	Global.chestId = Global.get_unique_id()
	

	animation_player.play("Idle")
	

# Function to extract node names from a debug message
func extract_node_names(message: String) -> Array:
	var names: Array = []
	
	# Split the message into lines
	var lines = message.split("\n")
	
	for line in lines:
		# Find the index of the ':' character
		var colon_index = line.find(":")
		
		if colon_index != -1:
			# Extract the node name from the beginning to the ':' character
			var node_name = line.substr(0, colon_index).strip_edges()
			names.append(node_name)
	
	return names
	
func find_node_by_name(root: Node, name: String) -> Node:
	if root.name == name:
		return root
	for child in root.get_children():
		var result = find_node_by_name(child, name)
		if result:
			return result
	return null
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and Global.available_ids.has(Global.chestLocalTestId) and not is_opened:
		var index = Global.available_ids.find(Global.chestLocalTestId)
		if index != -1:
			# Print before removal
			print("before removal", Global.available_ids)
			
			# Remove the item
			Global.available_ids[index] = ""
			
			# Check if index is still valid before accessing it
			if index < Global.available_ids.size():
				print("Index after removal", index, "with node", Global.available_ids[index])
				Global.currentlyPointedToId = Global.available_ids[index]
			else:
				print("Index out of bounds after removal. Array size:", Global.available_ids.size())
			
			# Update state
			is_opened = true

			var node_name = Global.chestName[0]
			var found_node = find_node_by_name(get_tree().root, node_name)
			var chest = found_node
			
			if found_node:
				print("Found node:", found_node.name)
			else:
				print("Node not found.")
			print("this is chest", chest)

			if chest and chest.has_node(animation_player.to_string()):
				var animation_player = chest.get_node("AnimationPlayer")
				animation_player.play("Open")
			else:
				print("Chest or AnimationPlayer not found.")

		else:
			print("Item to remove not found")
		
func _drop_object() -> void:
	var object: Node2D = object_scene.instance()

	object.position = self.global_position
	
	owner.get_parent().add_child(object)

	var drop_distance = 0

	var __ = tween.interpolate_property(object, "position", object.position, object.position + Vector2(0, drop_distance), 0.3, Tween.TRANS_QUAD,
							   Tween.EASE_OUT)
	__ = tween.start()
	
	yield(tween, "tween_completed")
	
func extract_number_from_string(text: String) -> int:
	# Length of "Chest"
	var prefix_length = 5  


	if text.length() > prefix_length:

		var number_part = text.substr(prefix_length, text.length() - prefix_length)

		if number_part.is_valid_integer():
			return int(number_part)
	
	return -1 

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s
	
func _on_Area2D_body_entered(body):
#	print("are we inside", Global.is_player_inside )
	var chestName = $".".to_string()
	Global.chestName = extract_node_names(chestName)
	
	print("current chest", Global.chestName)
	print("current chest", Global.chestIndex)
	var index = Global.available_ids.find(Global.chestLocalTestId)
	print("should be same as current chest", Global.available_ids[index])
	
	var stringifiedChestName = array_to_string(Global.chestName)
	# im actually a lunatic but if i get the number, maybe i can just get index of vailale_ids lol
	var getNumberOfChest = extract_number_from_string(stringifiedChestName)

	if getNumberOfChest:
		Global.chestIndex = getNumberOfChest
		Global.chestLocalTestId = Global.available_ids[getNumberOfChest - 1]

	print(Global.available_ids)
	Global.is_player_inside = true
	


func _on_Area2D_body_exited(body):
#	print("are we inside while we exit", Global.is_player_inside )
	Global.is_player_inside = false
	

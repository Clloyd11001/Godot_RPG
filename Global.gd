extends Node

var player_pos : Vector2

var COMBOS = true
var QUESTS = true
var FIRSTQUEST = false
# Stack to keep track of scene history
var scene_stack = []
var currentScene
var quest_completed
var waitingForPlayerToCompleteQuest
var questFINISHED
var item_names_inventory = []
var inventoryOpen = false
var firstQuestPosition
var npc_area = false
var is_player_inside = false
var inventoryItemInfo
var inventoryItemName
var menuIsOpen
var chestId: int = 0
var chestName
var chestIndex
var chestLocalTestId
var currentlyPointedToId
var available_ids: Array = []
var npcName
var npcNode
var npcNameFromFile


const firstScene = "res://Level1.tscn"
var firstQuestTimer = null 
func _ready():
	if Global.currentScene == 'TreeWall':
		Global.COMBOS = false
		Global.QUESTS = false
		
	if Global.currentScene == "Level1":
		Global.COMBOS = true
		Global.QUESTS = true
		Global.FIRSTQUEST = true
		

func start_first_quest_timer():
	firstQuestTimer = Timer.new()  # Create a new Timer node
	firstQuestTimer.wait_time = 10  # Set the duration of the timer (10 seconds in this case)
	firstQuestTimer.connect("timeout", self, "_on_first_quest_timer_timeout")  # Connect the timeout signal
	add_child(firstQuestTimer)  # Add the timer as a child of this node
	firstQuestTimer.start()  # Start the timer

func _on_first_quest_timer_timeout():
	print("Timer ended")

	# Stop the timer when it times out
	firstQuestTimer.stop() 
	
func update_scene(scene_to_be_changed_to):
	currentScene = scene_to_be_changed_to

# Load a scene and push it onto the stack
func switch_to_scene(scene_path):
	var scene = ResourceLoader.load(scene_path)
	if scene:
		scene_stack.append(scene)
		#print(scene_stack)
		var _sceneToSwitchTo = get_tree().change_scene(scene_path)

# Switch to the previous scene
func switch_to_previous_scene():
	if scene_stack.size() > 1:
		var previous_scene = firstScene # Get the previous scene	
		previous_scene = get_tree().change_scene(previous_scene)
	else:
		print("No previous scene to switch to.")

func has_item(itemName: String) -> bool:
	# Iterate through each item in the inventory
	for item in PlayerInventory.Inventory:
		# Check if the name of the item matches the specified name (case insensitive)
		if item["name"].to_lower() == itemName.to_lower():
			return true # Item found
	return false # Item not found

func _process(delta):
	if Global.FIRSTQUEST == true:
		# this needs work
		#start_first_quest_timer()
		QuestPointer.lookTowardsObject(firstQuestPosition)



func get_unique_id() -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_id: int
	while true:
		new_id = rng.randf_range(0, 1e9) 
		if not available_ids.has(new_id):
			available_ids.append(new_id)
			break
	return new_id

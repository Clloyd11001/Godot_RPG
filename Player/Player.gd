extends KinematicBody2D

signal experience_gained(growth_data)
signal inventory_data_ready(data)


const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const inventory_layer = preload("res://Inventory.tscn")
const itemDrop = preload("res://ItemDrop.gd")

export var ACCELERATION = 500
export var MAX_SPEED = 40
export var ROLL_SPEED = 100
export var FRICTION  = 350
#export var COMBOS = false

var quests_scene_path = "res://QuestNotification.tscn"  



export(PackedScene) var MAGIC: PackedScene = preload("res://Hitboxes and Hurtboxes/Fireball.tscn")


enum {
	MOVE,
	ROLL,
	ATTACK,
	COMBO
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var direction = Vector2()
var questMenu = false
var canLose
#var house = null setget set_house

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxPivot/SwordHitBox
onready var hurtBox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var questManager = get_node("QuestManager")
onready var lvl1scene = "res://Level1.tscn" 
onready var collisionShape = get_node("HurtBox/CollisionShape2D")
onready var playerSprite = get_node("Sprite")
onready var comboSprite = get_node("AnimatedSprite")
onready var questJournal = get_node("CanvasLayer2/Popup")
onready var player = get_node(".")
onready var PlayerInventory = $"/root/PlayerInventory"
onready var npc = preload("res://introCharacter.tscn")
#var npc_instance = npc.instance()

var experience = 0
var experience_total = 0
var noInput = false
# experience to reach next level, does a lot of math.. basically exponential gain
var experience_required = get_required_experience(stats.level + 1)
var house = null setget set_house
var playerObject = null


#var currentScene = Global.current_scene.filename



func _ready():
	var panel = get_node("Panel")
	panel.visible = false
	PlayerInventory.set_player(self)
	#questNotificationPanel.visible = false
	set_house(null)
	randomize()

	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
#	npc_instance.connect("popup_shown", self, "_on_popup_shown")

# This function is called when the signal is emitted
func _on_popup_shown():
	# Show the panel when the signal is emitted
	var panel = get_node("Panel")
	var label = panel.get_node("Label")
	label.text = "PixieDust has been added to the inventory"  # Set text again in case needed
	panel.visible = true  # Make the panel visible

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state(delta)
		COMBO:
			combo_state(delta)
	
#	showQuestNotification("MQ001")

func disable_input():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
#	Input.set_input_as_handled() 

func enable_input():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
	#Input.set_input_as_handled(false) 

func move_state(delta):
	if Global.inventoryOpen == false:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			roll_vector = input_vector
			swordHitbox.knockback_vector = input_vector
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/Attack/blend_position", input_vector)
			animationTree.set("parameters/Roll/blend_position", input_vector)
			animationState.travel("Run")
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		move()
		
		if Input.is_action_just_pressed("roll"):
			state = ROLL
		
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
		
		if Input.is_action_just_pressed("projectile"):
			disable_input()
			throw_magic(input_vector)
			enable_input()

		
			
func roll_state():
	velocity = roll_vector  * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	# slides to a stop, dependent on friction
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	animationState.travel("Attack")
	

	
# did nothing, get rid
func combo_state(_delta):
	pass

#	animationState.travel("Attack2Right")
	
	# check if over	
	

func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	if Global.COMBOS:
		if Combos.compare_buffer_with_combo_list():

			state = COMBO
			# move from attack to combo
			playerSprite.visible = false
			comboSprite.visible = true
			animationPlayer.play("Attack2Right")
			animationTree.set("parameters/Attack/active", false)
			animationTree.set("parameters/Combo/active", true)
			yield(animationPlayer, "animation_finished")
			playerSprite.visible = true
			comboSprite.visible = false
			# play combo animation, then go from combo to move again
			animationState.travel("Attack2Right")
			# Trigger transition in AnimationTree
			animationTree.set("parameters/Combo/active", false)
			animationTree.set("parameters/Move/active", true)
	# set state
	state = MOVE

	
#


#	if not animationPlayer.is_playing():
#		# Play the combo animation
#		animationPlayer.play("Attack2Right")
#		animationPlayer.queue("IdleRight")
#		animationPlayer.queue("IdleDown")
#		# Change the state to COMBO
#		state = COMBO
#		print("Combo animation playing")
#		animationTree.set("parameters/Combo/active", true)
#		animationTree.set("parameters/Move/active", false)
#		  # Set the state back to MOVE after the combo animation finish


# warning-ignore:shadowed_variable
func get_required_experience(level):
	# can test different feels on experience by altering the values
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)

func level_up():
	PlayerStats.level += 1
	experience_required = get_required_experience(PlayerStats.level + 1)
	# need to disable background movement
	$upgradeStatsPopup.popup()
	$upgradeStatsPopup/CanvasLayer.visible = true

	PlayerStats.allotedUpgradePoints += 3
	# Picks from random stat when player levels up

	# Can tinker with this to give attributes
#	var upgradeableStats = ['MAX_HP', 'STRENGTH', 'MAGIC']
#	var random_stat = upgradeableStats[randi() % upgradeableStats.size()]
#	# Increased by 1,2 or 3
#	set(random_stat, get(random_stat) + randi() % 4)

func throw_magic(magic_direction: Vector2):
	if MAGIC:
		var magic = MAGIC.instance()
		get_tree().current_scene.add_child(magic)
		magic.global_position = self.global_position
		
		var magic_rotation = magic_direction.angle()
		magic.rotation = magic_rotation		


func _on_HurtBox_area_entered(_area):
	canLose = false
	if PlayerStats.health > 0:
		if canLose == false:
			PlayerStats.health -= 0.5
			hurtBox.start_invincibility(1.5)
			hurtBox.create_hit_effect()
			var playerHurtSound = PlayerHurtSound.instance()
			get_tree().current_scene.add_child(playerHurtSound)
	if PlayerStats.health <= 0:
		print("we're dead")	
		var _gameOverScene = get_tree().change_scene("res://GameOver.tscn")


func _on_HurtBox_area_exited(_area):
	canLose = true

func set_house(new_house):
	if new_house != null:	
	#	textBox.queue_text("Press I to interact")
		pass
	else:
		pass
	house = new_house

func print_node_tree(node, indent=""):
	for child in node.get_children():
		print_node_tree(child, indent + "  ")

func find_node_by_name(node, name_to_find):
	if node.name == name_to_find:
		return node
	for child in node.get_children():
		var found_node = find_node_by_name(child, name_to_find)
		if found_node:
			return found_node
	return null
	
# Function to recursively extract node data
# Need to work on this some more
func extract_node_data(node):
	var node_data = {
		"item_data": {}
	}

	if node is Sprite:  # Check if the node is of type Sprite
		var item_name = node.name  # Get the name of the node

		var item_data = JsonData.LoadData("res://Data/ItemData.json")

		if item_data.has(item_name) == true:
			var item_description = item_data[item_name]["Description"]

			# Check if the item_name already exists in item_data
			if not node_data["item_data"].has(item_name):
				node_data["item_data"][item_name] = {
					"StackSize": 1,
					"Description": item_description
				}

	# Recursively extract data from child nodes
	for child in node.get_children():
		var child_data = extract_node_data(child)
		node_data["item_data"].merge(child_data["item_data"])

	#print("final data:", node_data)
	return node_data
func convert_to_json(node_data):
	#print("before ocnverted to json", node_data)
	return JSON.print(node_data)
	
func pick_up_item(body):
	playerObject = body

func check_if_item_data_is_empty(item_data: Dictionary) -> bool:
	return item_data["item_data"].empty() 

	
func _unhandled_input(event):
	if event.is_action_pressed("heal"):
		# potion logic, still need to make inventory keyboard selectable
		for item_data in PlayerInventory.Inventory:
			if item_data["name"] == "PotionCommon":
				PlayerStats.health += 1
			
	if event is InputEventKey and event.is_action_pressed("interact") and house != null:
		Global.player_pos = global_position
		house.enter()

	if Global.QUESTS:
		if event.is_action_pressed("Quests") and questJournal.visible == false:
			
			questJournal.popup()
			questMenu = true
			player.visible = false
			noInput = true
			
		elif event.is_action_pressed("Quests") and questJournal.visible == true:
			questJournal.hide()
			noInput = false
			player.visible = true
			
		Global.player_pos = global_position
		# This may be useful for keeping track between saves
		#Global.firstScene = (get_tree().current_scene.filename)
	else:
		pass
	# TODO when picking up some items even when changing their sprites its using the previous object?
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			# Extract node data
			var pickup_item_data = extract_node_data(pickup_item)
			if check_if_item_data_is_empty(pickup_item_data) == false:	
				Global.inventoryItemInfo = pickup_item_data
				# Convert node data to JSON format
				emit_signal("inventory_data_ready", pickup_item_data)
				if pickup_item_data != null:
	#				print("this is the item to pickup", pickup_item)
					pick_up_item(pickup_item)
					$PickupZone.items_in_range.erase(pickup_item_data)
					pickup_item.queue_free()
				else:
					print("Debug: Item cannot be picked up or doesn't have a sprite.")
			else:
				print("Debug: Item cannot be picked up or doesn't have a sprite.")
		else:
			print("Debug: No items in range.")

func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
	


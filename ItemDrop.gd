extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false

var testInventory = []



func _ready():
	# I wanted to test this append so that I could just append stuff into the array above..
	# If i get this to work, i can assign whatever sprites i want to chests and then just go back and 
	# append what the name of the sprite is (then it finds the corresponding .png file 
#	testInventory.append("Ruby")
#	testInventory.append("Skull")
#	testInventory.append("Brain")
#
#	for i in testInventory:
#		item_name = i
#		print(item_name)
	item_name = "AnimalSkull"


func _physics_process(delta):
	if being_picked_up == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance > 4:
			PlayerInventory.add_item(item_name, 1)

			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true

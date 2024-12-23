extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false


func _ready():
#	var rand_val = randi() % 2
#	if rand_val == 0:
#		item_name = "Ruby"
#	elif rand_val == 1:
#		item_name = "Skull"
	pass


func _physics_process(delta):
	if being_picked_up == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance > 4:
			PlayerInventory.add_item(item_name, 1, "test")

			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true

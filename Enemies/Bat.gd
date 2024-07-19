extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

signal enemy_defeated 

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var sprite = get_node("AnimatedSprite")
onready var stats = $Stats

onready var playerDetectionZone = get_node("PlayerDetectionZone")
onready var hurtbox = get_node("HurtBox")
onready var softCollision = get_node("SoftCollision")
onready var wanderController = get_node("WanderController")
onready var animationPlayer = get_node("AnimationPlayer")

var rng = RandomNumberGenerator.new()

var allPossibleDrops = []  

func _ready():
	state = pick_random_state([IDLE, WANDER])
	drop_object_from_enemy(rng.randi_range(0, 10))
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
	
func _on_HurtBox_invincibility_started():
	animationPlayer.play("Start")
func _on_HurtBox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_HurtBox_area_entered(area):
	stats.health -= 1
	print("enemy health?", stats.health)
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func drop_object_from_enemy(seedVariable) -> void:

	var items_dir_path = "res://Items/"
	var dir = Directory.new()
	var error = dir.open(items_dir_path)
	
	if error == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# Skip directories, process only files
				file_name = dir.get_next()
				continue
			
			var file_path = items_dir_path + file_name
#			print("HERES THE FILE PATH", file_path)
#			print("HERES THE FILE NAME", file_name)
			
			if file_name.get_extension().to_lower() == "png":
				allPossibleDrops.append(items_dir_path + file_name)
				print("SO HERES WHAT ITS LIKE AT THE END",allPossibleDrops[0])

			
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Error opening directory:", items_dir_path)

# TODO: NEED TO WORK ON THIS TO BE ABLE TO ADD ENEMY DROPS (7/18)
#	var tween:Tween = get_node("Tween")
#	if  tween:
#
#		var drop_distance = 2
#
#		var drop_tween = tween.interpolate_property(allPossibleDrops, "position", allPossibleDrops.position, allPossibleDrops.position + Vector2(0, drop_distance), 0.3, Tween.TRANS_QUAD,
#								   Tween.EASE_OUT)
#
#		var rise_tween = tween.interpolate_property(allPossibleDrops, "position", allPossibleDrops.position + Vector2(0, drop_distance), allPossibleDrops.position, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN, 0.5)
#
#		tween.start()
#
#		yield(tween, "tween_completed")

func _process(_delta):

	if stats.health == 0:
		queue_free()
		var enemyDeathEffect = EnemyDeathEffect.instance()
		get_parent().add_child(enemyDeathEffect)
		enemyDeathEffect.global_position = global_position
		# testing to see if gaining experience should go here
		emit_signal("enemy_defeated")
		


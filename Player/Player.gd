extends KinematicBody2D

signal experience_gained(growth_data)

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
onready var inventory_layer = $inventory

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 100
export var FRICTION  = 350

# CHARACTER STATS
export (int) var MAX_HP = 12
export (int) var STRENGTH = 8
export (int) var MAGIC = 8
# LEVELING SYSTEM
export (int) var level = 1


enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
#var house = null setget set_house

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitBoxPivot/SwordHitBox
onready var hurtBox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer


var experience = 0
var experience_total = 0

# experience to reach next level, does a lot of math.. basically exponential gain
var experience_required = get_required_experience(level + 1)

var house = null setget set_house

func _ready():

	set_house(null)
	randomize()
# warning-ignore:return_value_discarded
	PlayerStats.connect("no_health",self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state(delta)
			
			
func move_state(delta):
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
	
		
func roll_state():
	velocity = roll_vector  * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	# slides to a stop, dependent on friction
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

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
	level += 1
	experience_required = get_required_experience(level + 1)
	# Picks from random stat when player levels up
# warning-ignore:shadowed_variable
	# Can tinker with this to give attributes
	var stats = ['MAX_HP', 'STRENGTH', 'MAGIC']
	var random_stat = stats[randi() % stats.size()]
	# Increased by 1,2 or 3
	set(random_stat, get(random_stat) + randi() % 4)

func _on_HurtBox_area_entered(_area):
	PlayerStats.health -= 1
	hurtBox.start_invincibility(0.6)
	hurtBox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func set_house(new_house):
	if new_house != null:	
	#	textBox.queue_text("Press I to interact")
		pass
	else:
		pass
	house = new_house

func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("interact") and house != null:
		Global.player_pos = global_position
		house.enter()
	if event is InputEventKey and event.is_action_pressed("Menu"):
		inventory_layer.visible = not inventory_layer.visible
	else:
		pass


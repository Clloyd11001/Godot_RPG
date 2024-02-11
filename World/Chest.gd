extends AnimatedSprite

var is_player_inside: bool = false
var is_opened: bool = false

var rng = RandomNumberGenerator.new()
var my_random_index: int = rng.randi_range(0,2)


# List of scenes (PackedScene objects)
var scenes: Array = [
					 preload("res://item_icons/VoodooDoll.tscn"),
					 preload("res://item_icons/AnimalSkull.tscn"),
					 preload("res://item_icons/Brain.tscn")]

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tween: Tween = get_node("Tween")

func _ready() -> void:
	animation_player.play("Idle")
	my_random_index = rng.randi_range(0, scenes.size() - 1) # Generate a random index within the range of scenes array

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_inside and not is_opened:
		animation_player.play("Open")
		_drop_object() # Call the function to drop the object when interacting

func _drop_object() -> void:
	var object_scene: PackedScene = scenes[my_random_index] # Retrieve the scene corresponding to the random index
	var object_instance: Node2D = object_scene.instance() as Node2D # Instance the scene
	owner.get_parent().add_child(object_instance) # Add the instance to the scene tree
	object_instance.global_position = global_position # Set the position of the instance
	print(my_random_index)

func _on_Area2D_player_entered(_player):
	is_player_inside = true

func _on_Area2D_player_exited(_player):
	is_player_inside = false


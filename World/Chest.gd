extends AnimatedSprite



var is_player_inside: bool = false
var is_opened: bool = false

var rng = RandomNumberGenerator.new()
var my_random_number = rng.randf_range(-10.0, 10.0)

var scenes = [preload("res://item_icons/AnimalSkull.png"), preload("res://item_icons/VoodooDoll.png"),preload("res://item_icons/AnimalSkull.png"),preload("res://item_icons/Brain.png")]

# gets a random element of scene (skull, voodoo doll, etc) My thought process is that when I open a chest, it will select a random object scene in the array
# this would need to be further stretched for rarity, if I open chest, choose 1-3 if 1 show common, 2 rare, 3 legendary
# so maybe ill make a bronze_scenes, silver_scenes and gold_scenes
# may need to look at item.gd to specify which item is being chosen.. maybe ill export the variable name?
export(StreamTexture) var object_scene: StreamTexture = scenes[my_random_number]


onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tween:Tween = get_node("Tween")

func _ready() -> void:
	animation_player.play("Idle")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_inside and not is_opened:
		animation_player.play("Open")

func _drop_object() -> void:
	var object: Node2D = object_scene.instance()

	owner.get_parent().add_child(object)
	
	var __ = tween.interpolate_property(object, "position", position, position + Vector2(0, -5), 0.3, Tween.TRANS_QUAD,
							   Tween.EASE_OUT)
	__ = tween.start()
	
	yield(tween, "tween_completed")
	
	__ = tween.interpolate_property(object, "position", position + Vector2(0, -5), position, 0.3, Tween.TRANS_SINE,
							   Tween.EASE_IN)
	__ = tween.start()

func _on_Area2D_player_entered(_player):
	is_player_inside = true


func _on_Area2D_player_exited(_player):
	is_player_inside = false

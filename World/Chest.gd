extends AnimatedSprite

export(PackedScene) var object_scene: PackedScene = null

var is_player_inside: bool = false
var is_opened: bool = false

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var Tween = get_node("Tween")

func _ready() -> void:
	#assert(object_scene != null)
	animation_player.play("Idle")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_inside and not is_opened:
		animation_player.play("Open")

func _drop_object() -> void:
	var object: Node2D = object_scene.instance()
	#get_node("/root/Level1/YSort/Chests/Chest").add_child(object)

	
#	Tween.interpolate_property(object, "position", position, position + Vector2(0, -5), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
#
#	Tween.start()
#
#	yield(Tween, "tween_completed")
#
#	Tween.interpolate_property(object, "position", position + Vector2(0, -5),position, 0.3, Tween.TRANS_SINE, Tween.EASE_IN)
#
#	Tween.start()
	


func _on_Area2D_player_entered(_player):
	is_player_inside = true


func _on_Area2D_player_exited(_player):
	is_player_inside = false

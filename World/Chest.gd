extends AnimatedSprite

export(PackedScene) var object_scene: PackedScene = preload("res://Items/Transperent/AnimalSkullDrop.tscn")

var is_player_inside: bool = false
var is_opened: bool = false

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tween:Tween = get_node("Tween")

func _ready() -> void:
	animation_player.play("Idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and Global.is_player_inside and not is_opened:
		is_opened = true
		animation_player.play("Open")
		
func _drop_object() -> void:
	var object: Node2D = object_scene.instance()

	object.position = self.global_position
	
	owner.get_parent().add_child(object)

	var drop_distance = 0

	var __ = tween.interpolate_property(object, "position", object.position, object.position + Vector2(0, drop_distance), 0.3, Tween.TRANS_QUAD,
							   Tween.EASE_OUT)
	__ = tween.start()
	
	yield(tween, "tween_completed")


func _on_Area2D_body_entered(body):
	Global.is_player_inside = true


func _on_Area2D_body_exited(body):
	Global.is_player_inside = false

extends Node2D


onready var animatedSprite = get_parent().get_node("AnimatedSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.connect("starting_bomb_toss", self, "_on_starting_bomb_toss")



func run_tween() -> void:
	$Path2D/PathFollow2D/Bomb/Tween.interpolate_property(
		$Path2D/PathFollow2D, "unit_offset",
		0.0, 1.0, 3.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Path2D/PathFollow2D/Bomb/Tween.start()
	get_parent().get_node("Node2D/Path2D/PathFollow2D/Bomb").play("bombExplode")
	yield($Path2D/PathFollow2D/Bomb/Tween, "tween_all_completed")
	
	

func _on_starting_bomb_toss():
	print("ayyyyy")
	animatedSprite.stop()
	get_parent().get_node("Node2D/Path2D/PathFollow2D/Bomb").visible = true
	run_tween()

	animatedSprite.play("idle")

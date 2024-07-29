extends Node2D

onready var animatedSprite = get_parent().get_node("AnimatedSprite")
onready var throwingBombAnimation = get_parent().get_node("AnimatedSprite")
var tween_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.connect("starting_bomb_toss", self, "_on_starting_bomb_toss")
	run_tween()

func run_tween() -> void:
	var tween = $Path2D/PathFollow2D/Bomb/Tween
	tween.interpolate_property(
		$Path2D/PathFollow2D, "unit_offset",
		0.0, 1.0, 2.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	get_parent().get_node("Node2D/Path2D/PathFollow2D/Bomb").play("bombExplode")

	tween.connect("tween_completed", self, "_on_tween_completed")

func _on_tween_completed(object, key):
	# Optionally handle any logic needed after tween completion
	# Do not reset unit_offset or start the tween again if you want to maintain the end position
	throwingBombAnimation.play("throwBomb")
	run_tween()

func _on_starting_bomb_toss():
	animatedSprite.stop()
	get_parent().get_node("Node2D/Path2D/PathFollow2D/Bomb").visible = true
	run_tween()

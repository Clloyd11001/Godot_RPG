extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	
func _draw():
	draw_line(Vector2.ZERO, Vector2.RIGHT * 60, Color.white, 4.0)
	draw_line(Vector2.ZERO, Vector2.DOWN * 55, Color.white, 4.0)
	

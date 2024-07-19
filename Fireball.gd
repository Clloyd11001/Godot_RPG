extends "res://Hitboxes and Hurtboxes/HitBox.gd"

export(int) var SPEED: int = 100
var knockback_vector = Vector2(1, 0).normalized() * 0.5

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()

func _on_Fireball_area_entered(_area):
	#destroy()
	pass

func _on_Fireball_body_entered(_body):
	#destroy()
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

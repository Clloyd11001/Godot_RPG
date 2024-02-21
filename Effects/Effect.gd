extends AnimatedSprite


func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	# Animation doesn't exist,  but if u take out it breaks the hit effect
	play("Animate")


func _on_animation_finished():
	queue_free()

extends TextureProgress

# i know this is convoluded lol
onready var player = get_parent().get_parent().get_parent().get_parent()

func _ready():
	player.connect("experience_gained", self, "_on_Player_experience_gained")
	print("experiencebarexperiencebarexperiencebarexperiencebarexperiencebar", rect_global_position)
func initialize(current, maximum):
	max_value = maximum
	value = current

func _on_Player_experience_gained(growth_data):
	print("we gained experience")
	for line in growth_data:
		var target_exp = line[0]
		var max_exp = line[1]
		max_value = max_exp
		yield(animate_value(target_exp), "completed")
		if abs(max_value - value) < 0.01:
			value = 0.0

func animate_value(target, tween_duration=1.0):
	$Tween.interpolate_property(self, "value", value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")




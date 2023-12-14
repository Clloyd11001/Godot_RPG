extends Node2D

# THIS IS JUST STARTER CODE, WILL UPDATE LATER

var combo_sequence := []
var max_combo_length := 3
var combo_timer := 0.5
var current_combo_timer := 0.0

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		combo_sequence.append("attack")
		current_combo_timer = combo_timer

	if current_combo_timer > 0:
		current_combo_timer -= delta
	else:
		combo_sequence = []

	if combo_sequence.size() > max_combo_length:
		combo_sequence.pop_front()

	if check_combo(["attack", "attack", "attack"]):
		# Perform action for successful combo
		print("Combo performed!")

func check_combo(target_combo):
	if combo_sequence.size() < target_combo.size():
		return false

	for i in range(target_combo.size()):
		if combo_sequence[i] != target_combo[i]:
			return false

	return true

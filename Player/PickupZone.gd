extends Area2D

var items_in_range = []

func _on_PickupZone_body_entered(body):
	# Append the body to the array
	items_in_range.append(body)

func _on_PickupZone_body_exited(body):
	# Remove the body from the array if it exists
	if items_in_range.has(body):
		items_in_range.erase(body)

extends Area2D

var items_in_range = {}

func _on_PickupZone_body_entered(body):
	# Append the body to the array
	print("Entered pickup zone")
	if body == get_parent():
		print("Detecting player body")
		return
	#append items in array	
	items_in_range[body] = body

func _on_PickupZone_body_exited(body):
	# Remove the body from the array if it exists
	if items_in_range.has(body):
		items_in_range.erase(body)

extends ColorRect

var inventory = preload("res://Inventory.tres")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
	# Set item back to original index
func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)

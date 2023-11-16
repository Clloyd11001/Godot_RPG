extends Resource


var drag_data = null

const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = preload("res://InventoryContainer.gd")

signal items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null,
]
func _ready():
	initialize_inventory()

func set_item(item_index, item):
	var previousItem = items[item_index]
	
	if previousItem is Item and previousItem.name == item.name:
		previousItem.amount += item.amount
	else:
		items[item_index] = item
	
	emit_signal("items_changed", [item_index])
	
	return previousItem

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items

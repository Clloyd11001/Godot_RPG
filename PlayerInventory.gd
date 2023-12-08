extends Node

const SlotClass = preload("res://Slot.gd")
const ItemClass = preload("res://Item.gd")
const NUM_INVENTORY_SLOTS = 20



func _ready():
	# Initialize Inventory as an empty dictionary
	pass
var Inventory = {
#	0: ["Skull", 1],
#	1: ["Skull", 1]
}

func add_item(item_name, item_quantity):
	for item in Inventory:
		if Inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - Inventory[item][1]
			if able_to_add >= item_quantity:
				Inventory[item][1] += item_quantity
				return
				
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if Inventory.has(i) == false:
			Inventory[i] = [item_name, item_quantity]
			return

func remove_item(slot: SlotClass):
	Inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	Inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	Inventory[slot.slot_index][1] += quantity_to_add

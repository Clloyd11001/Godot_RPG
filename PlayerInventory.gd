extends Node

const SlotClass = preload("res://Slot.gd")
const ItemClass = preload("res://Item.gd")
const NUM_INVENTORY_SLOTS = 20

var player = null
onready var itemInforArray

func set_player(player_ref):
	player = player_ref

func _ready():
	# Initialize Inventory as an empty dictionary
	call_deferred("_connect_to_player")

func _connect_to_player():
	if not player:
		player = get_tree().root.get_node("Player")
	if player:
		player.connect("inventory_data_ready", self, "_on_inventory_data_ready")


var Inventory = []

func add_item(item_name, item_quantity):

#	for i in range(Inventory.size()):
#		var item_data = Inventory[i]
#		print('heres item data', item_data)
#		if item_data[0] == item_name:  # Check if the item name matches
#			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
#			var able_to_add = stack_size - item_data[1]
#			if able_to_add >= item_quantity:
#				item_data[1] += item_quantity  # Update the quantity
#				Inventory[i] = item_data  # Update the item data in the array
#				return
	# If the item doesn't exist in inventory yet, find an empty slot and add it
	for i in range(NUM_INVENTORY_SLOTS):
		if i >= Inventory.size():
			# If the array size is smaller than the slot index, extend it
			Inventory.resize(i + 1)
		if Inventory[i] == null:  # Check if the slot is empty
			Inventory[i] = [item_name, item_quantity]  # Add the item data to the array
			return


func remove_item(slot: SlotClass):
	Inventory.erase(slot.slot_index)

func add_item_to_empty_slot(Item: ItemClass, slot: SlotClass):
	Inventory[slot.slot_index] = [Item.item_name, Item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	Inventory[slot.slot_index][1] += quantity_to_add


func _on_inventory_data_ready(data):
	Inventory.clear()
	var item_data = data["item_data"]
	var itemInfoArray = [] # Initialize an empty array to store item info
	
	for item_name in item_data.keys():
		var item_details = item_data[item_name]
		var item_info = {
			"name": item_name,
			"description": item_details["Description"],
			"quantity": item_details["StackSize"]
		}
		itemInfoArray.append(item_info) # Append item info to the array
	Inventory = itemInfoArray
#	print(Inventory) # Print all item info after the loop


extends Node

signal active_item_updated 

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
		print(get_tree().root)
	if player:
		player.connect("inventory_data_ready", self, "_on_inventory_data_ready")


var Inventory = []

var active_item_slot = 0

func add_item(item_name, item_quantity,item_description ):
	for item_data in Inventory:
		if item_data["name"] == item_name:
			item_data["quantity"] += item_quantity
			print("Added", item_quantity, "to", item_name, "in inventory.")
			print("Current inventory state:", Inventory)
			return

	# If the item doesn't exist in the inventory yet, find an empty slot and add it
	for i in range(NUM_INVENTORY_SLOTS):
		if i >= Inventory.size():
			# If the array size is smaller than the slot index, extend it
			Inventory.resize(i + 1)
		if Inventory[i] == null:  
			Inventory[i] = {"name": item_name, "quantity": item_quantity, "description": item_description} 
			return



func remove_item(slot: SlotClass):
	Inventory.erase(slot.slot_index)

func add_item_to_empty_slot(Item: ItemClass, slot: SlotClass):
	Inventory[slot.slot_index] = [Item.item_name, Item.item_quantity]
	print("item is" + Item.item_name + "and index is" + slot.slot_index)

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	for item_data in Inventory:
		if item_data["name"] == slot.item.item_name:
			item_data["quantity"] += quantity_to_add
			return

func _on_inventory_data_ready(data):
	var item_data = data["item_data"]
	for item_name in item_data.keys():
		var item_details = item_data[item_name]
		var item_quantity = item_details["StackSize"]
		var item_description = item_details["Description"]
		add_item(item_name, item_quantity, item_description)


func active_item_scroll_through_right():
	if Global.menuIsOpen:
		active_item_slot = (active_item_slot + 1) % NUM_INVENTORY_SLOTS 


func active_item_scroll_through_left():
	if Global.menuIsOpen:
		if active_item_slot == 0:
			active_item_slot = NUM_INVENTORY_SLOTS - 1
		else:
			active_item_slot -= 1



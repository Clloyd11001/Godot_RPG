extends Node2D

const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = $GridContainer
var holding_item = null
var inventory_data_array = []
onready var Player = get_parent().get_parent()
var item_names = []

func _ready():
#	print("parent?", Player)
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
	Player.connect("inventory_data_ready", self, "_on_inventory_data_ready")
	initialize_inventory()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	var inventory = PlayerInventory.Inventory
	print("inventory", inventory)
	for i in range(slots.size()):
		if i < inventory.size():
			var item_info = inventory[i]
			var item_name = item_info["name"]
			var item_quantity = item_info["quantity"]
			slots[i].initialize_item(item_name, item_quantity)
			print("heres the quantity", inventory)
			item_names.append(item_name)
			Global.item_names_inventory = item_names
		else:
			pass
	print("heres the inventory", inventory)


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding an Item
			if holding_item != null:
				# Empty slot
				if !slot.item:
					left_click_empty_slot(slot)
				# Slot already contains an item	
				else:
					# Different item, so swap
					if holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					# Same item, so try to merge
					else:
						left_click_same_item(slot)
			# Not holding an item				
			elif slot.item:
				left_click_not_holding(slot)
				
func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
	if Input.is_action_pressed("ui_left"):
		PlayerInventory.active_item_scroll_through_left()
	elif Input.is_action_pressed("ui_right"):
		PlayerInventory.active_item_scroll_through_right()
		
func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null

func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, holding_item)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
	

func _on_inventory_data_ready(data):
	print("test data", data)
	if inventory_data_array.has(data):
		print("already have it")
	inventory_data_array.append(data)


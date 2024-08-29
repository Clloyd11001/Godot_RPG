extends CanvasLayer

var json_data_to_be_sent = {};
var inventory_data_array = []

onready var Player = get_parent()
func _ready():
	# Connect to the player's signal
	pass

func _input(event):
	if event.is_action_pressed("Menu"):
		$Inventory.visible = !$Inventory.visible
		Global.inventoryOpen = !Global.inventoryOpen
		if $Inventory.visible:
			# need to disable input, give it to inventory to make keyboard selectable
			$Inventory.initialize_inventory()
			Global.menuIsOpen = true
			if event.is_action_pressed("ui_left"):
				PlayerInventory.active_item_scroll_through_left()
			if event.is_action_pressed("ui_right"):
				PlayerInventory.active_item_scroll_through_right()
			if Global.inventoryItemInfo:
				print("has something in it, now well see if we can get it")
				var item_data = Global.inventoryItemInfo["item_data"]
				for item_name in item_data.keys():
					Global.inventoryItemName = item_name			
					print("Name:",Global.inventoryItemName)
		else:
			Global.menuIsOpen = false


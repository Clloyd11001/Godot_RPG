extends CanvasLayer

var json_data_to_be_sent = {};
var inventory_data_array = []

onready var Player = get_parent()
func _ready():
	# Connect to the player's signal
	pass

# Handle the inventory data ready signal
# once we recieve that data, do exactly the same logic as we had before but change it from a button pressed into a signal
# so after this everytime we pickup, this should fire then once it sends the data, we should automatically send the http PUT
# i have a button for the GET right now, is_action_pressed("http") but that code should go into the inventory
# so that when we open the inventory it does a GET



func _input(event):
	if event.is_action_pressed("Menu"):
		$Inventory.visible = !$Inventory.visible
		Global.inventoryOpen = !Global.inventoryOpen
		if $Inventory.visible:
			# need to disable input, give it to inventory to make keyboard selectable
			$Inventory.initialize_inventory()
			if event.is_action_pressed("ui_left"):
				PlayerInventory.active_item_scroll_through_left()
			if event.is_action_pressed("ui_right"):
				PlayerInventory.active_item_scroll_through_right()
			
#	if event.is_action_pressed("http"):
#		print("Sending HTTP request...")
#		$HTTPRequest.request("http://localhost:3000/api/items")

## PROCESS IS CURRENTLY, PICK UP ITEM, PRESS H THEN PRESS MENU AND IT WORKS

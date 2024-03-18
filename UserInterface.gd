extends CanvasLayer

var json_data_to_be_sent = {};
onready var Player = get_parent()
func _ready():
	# Connect to the player's signal
	Player.connect("inventory_data_ready", self, "_on_inventory_data_ready")

# Handle the inventory data ready signal
# once we recieve that data, do exactly the same logic as we had before but change it from a button pressed into a signal
# so after this everytime we pickup, this should fire then once it sends the data, we should automatically send the http PUT
# i have a button for the GET right now, is_action_pressed("http") but that code should go into the inventory
# so that when we open the inventory it does a GET

## New problem is failing to send json as of 3/15
func _on_inventory_data_ready(data):
	# So we know we're getting the singal
	#Received inventory data:{"name":"ItemDrop","type":"KinematicBody2D","children":[{"name":"Skull","type":"Sprite","children":[]},{"name":"Ruby","type":"Sprite","children":[]},{"name":"CollisionShape2D","type":"CollisionShape2D","children":[]},{"name":"AnimationPlayer","type":"AnimationPlayer","children":[]},{"name":"Brain","type":"Sprite","children":[]}]}

	print("Received inventory data:", data)
	json_data_to_be_sent = data
	# Convert data to JSON
	var query = JSON.print(data)
	print("-----------------------------------")
	#print("Received inventory data:", query)
	var headers = ["Content-Type: application/json"]

	# Send HTTP request
	print("Sending data via HTTP...")
	print("data",data)
	# just passed in data without query and it worked, weird
	$HTTPRequest.request("http://localhost:3000/api/items", headers, true, HTTPClient.METHOD_PUT, data)

func _input(event):
	if event.is_action_pressed("Menu"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
	if event.is_action_pressed("http"):
		print("Sending HTTP request...")
		$HTTPRequest.request("http://localhost:3000/api/items")

## PROCESS IS CURRENTLY, PICK UP ITEM, PRESS H THEN PRESS MENU AND IT WORKS

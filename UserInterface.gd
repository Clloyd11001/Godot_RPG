extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _input(event):
	if event.is_action_pressed("Menu"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
	if event.is_action_pressed("http"):
		print("Sending HTTP request...")
		$HTTPRequest.request("http://localhost:3000/api/items")
	if event.is_action_pressed("sendhttp"):
		print("Sending data via HTTP...")
		var data =  {
					0: ["Skull", 1],
					1: ["Ruby", 1],
					2: ["Brain",1]
				}

		
		var query = JSON.print(data)
		var headers = ["Content-Type: application/json"]
		$HTTPRequest.request("http://localhost:3000/api/items", headers, true, HTTPClient.METHOD_PUT, query)


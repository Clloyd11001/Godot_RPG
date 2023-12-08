extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(event):
	if event.is_action_pressed("Menu"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
func _ready():
	pass

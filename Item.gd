extends Node2D

var item_name
var item_quantity

func _ready():

	item_name = "Skull"
	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://item_icons/" + item_name + '.png')
	
	if item_name in JsonData.item_data:
		var stack_size = int(JsonData.item_data[item_name]['StackSize'])
		if stack_size == 1:
			$Label.visible = false
		else:
			$Label.visible = true
			$Label.text = str(item_quantity)
	else:
		print("Item", item_name, "not found in item_data")
#
#	var stack_size = int(JsonData.item_data[item_name]['StackSize'])
#	if stack_size == 1:
#		$Label.visible = false
#	else:
#		$Label.visible = true
#		$Label.text = String(item_quantity)

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)

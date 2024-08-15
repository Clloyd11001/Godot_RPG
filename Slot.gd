extends GridContainer

onready var selectedImageRect = get_parent().get_node("Popup/TextureRect")
onready var selectedImagePopUp = get_parent().get_node("Popup")
onready var itemName = get_parent().get_node("Popup/Label")
onready var itemDescription = get_parent().get_node("Popup/RichTextLabel")

var default_tex = preload("res://item_slot_default_background.png")
var empty_tex = preload("res://item_slot_empty_background.png")
var selected_text = preload("res://UI/item_slot_selected_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Item.tscn")
var item = null
var selected = true  
var slot_index = get_index()
var isPopupVisible = false


func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_text
	
	refresh_style()


func refresh_style():
	var slot_index = clamp(PlayerInventory.active_item_slot, 0, get_child_count() - 1)
#	print("index:", slot_index)
	for i in range(get_child_count() - 1):
		var slot = get_node("Slot" + str(i + 1))
		if slot:
			slot.set('custom_styles/panel', default_style)  
	# Apply selected style to the currently active slot (we can change this later on)
	if selected:
		var active_slot = get_node("Slot" + str(slot_index + 1))
		active_slot.set('custom_styles/panel', selected_style)

	
func set_selected(selected_state: bool):
	selected = selected_state
	refresh_style()

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

func _process(delta):
	slot_index = PlayerInventory.active_item_slot
	refresh_style() 

func _input(event):
	if event.is_action_pressed("ui_accept") and Global.inventoryOpen:
		if isPopupVisible:
			isPopupVisible = false
			selectedImagePopUp.hide()
		else:
	# Check if the Inventory array is not empty
			if not PlayerInventory.Inventory.empty():
				var index = PlayerInventory.active_item_slot

				# Check if the index is within bounds
				if index >= 0 and index < PlayerInventory.Inventory.size():
					var value = PlayerInventory.Inventory[index]

					# Check if the value at the index is a dictionary
					if typeof(value) == TYPE_DICTIONARY:
						var selectedItemDictionary = value

						# Check if the dictionary is not empty
						if not selectedItemDictionary.empty():
							
							# Retrieve item details
							var selectedItem = selectedItemDictionary.get("name", "")
							var selectedItemImage = selectedItem + '.png'
							var selectedTexture = load("/item_icons/" + selectedItemImage)

							var itemNameText = selectedItem
							var itemDescriptionText = selectedItemDictionary.get("description", "")
							var itemQuantity = selectedItemDictionary.get("quantity", 0)
							var itemQuantityText = "x " + str(itemQuantity)

							# Update the UI
							itemName.text = itemNameText + " " + itemQuantityText
							itemDescription.bbcode_text = itemDescriptionText
							selectedImageRect.texture = selectedTexture
							selectedImagePopUp.popup_centered()
							isPopupVisible = true
						else:
							print("Selected item dictionary is empty.")
					else:
						print("The value at the index is not a dictionary.")
				else:
					print("Index is out of bounds.")
			else:
				print("Inventory is empty.")

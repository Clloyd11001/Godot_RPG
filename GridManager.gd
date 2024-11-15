extends GridContainer

onready var itemPopup = get_parent().get_node("Popup")
onready var itemPopupTextureRect = get_parent().get_node("Popup/TextureRect")
onready var itemPopupName = get_parent().get_node("Popup/Label")
onready var itemPopupDescription = get_parent().get_node("Popup/RichTextLabel")

var inventorySlots = []  # Holds references to all SlotDisplay nodes
var activeSlotIndex = -1  # Holds the index of the selected slot
var isPopupVisible = false

# Called when the inventory grid is ready
func _ready():
	# Initialize slots from the GridContainer's children (the slots)
	for slot in get_children():
		inventorySlots.append(slot)
		slot.connect("item_selected", self, "_on_item_selected")

	initialize_inventory()  # Set up inventory items

# Initializes the inventory with data from the player inventory
func initialize_inventory():
	var playerInventory = PlayerInventory.Inventory  # Assumed data structure
	
	for i in range(inventorySlots.size()):
		if i < playerInventory.size():
			var itemInfo = playerInventory[i]
			inventorySlots[i].initialize_item(itemInfo["name"], itemInfo["quantity"])
		else:
			inventorySlots[i].initialize_item("", 0)  # Empty slot

# Handles the event when an item is selected in a slot
func _on_item_selected(itemName, itemDescription, itemTexture):
	itemPopupName.text = itemName
	itemPopupDescription.bbcode_text = itemDescription
	itemPopupTextureRect.texture = itemTexture
	itemPopup.popup_centered()
	isPopupVisible = true

# Refresh the grid, potentially based on changes to active slots or inventory
func refresh_inventory():
	for slot in inventorySlots:
		slot.refresh_style()


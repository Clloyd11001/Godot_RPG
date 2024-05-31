extends GridContainer


var default_tex = preload("res://item_slot_default_background.png")
var empty_tex = preload("res://item_slot_empty_background.png")
var selected_text = preload("res://UI/item_slot_selected_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Item.tscn")
var item = null
var selected = true  # Track whether this slot is selected
var slot_index = get_index()

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_text
	
	refresh_style()
	
		
func refresh_style():
	var slot_index = PlayerInventory.active_item_slot

	# Reset all slots to default or empty style
	
	for i in range(get_child_count() - 1):
		var slot = get_node("Slot" + str(i + 1))
		if slot:
			slot.set('custom_styles/panel', default_style)  # or empty_style

	# Apply selected style to the currently active slot
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
#		PlayerInventory.Inventory[slot_index]["name"]
		print("heres the selected item:", PlayerInventory.Inventory)

extends Control

var viewportWidth = get_viewport()



onready var questBackground = $TextureRect
onready var questLabel = $Label
onready var questNotificationLabel = get_node("Label")
onready var font = questNotificationLabel.get_font("font") as DynamicFont



func _ready():
	if questLabel and questBackground:
		# changes the treewall font, but not the quest journal 
#		questNotificationLabel.get_font('font').size = 5
		pass
	



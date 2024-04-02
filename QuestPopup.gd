extends Control

var viewportWidth = get_viewport()



onready var questBackground = $TextureRect
onready var questLabel = $Label
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if questLabel and questBackground:
		pass
#		questBackground.visible = true
#		print(get_viewport_rect().size)
#		questBackground.set_size(get_viewport_rect().size, true) 
#		questLabel.set_size(get_viewport_rect().size, true) 
	



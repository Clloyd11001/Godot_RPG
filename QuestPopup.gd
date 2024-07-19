extends Control

var viewportWidth = get_viewport()



onready var questBackground = $TextureRect
onready var questLabel = $Label
onready var questNotificationLabel = get_node("Label")

onready var animation = get_node("AnimationPlayer")


func _ready():
#	var fontSizeNumber = questNotificationLabel.get_font("font")
#	fontSizeNumber.size = 12


	if Global.quest_completed:
		playAnimation()
	else:
		pass
		
func _process(_delta):
	if Global.quest_completed:
		playAnimation()

func playAnimation():
	animation.play("GrowQuestPopUp")





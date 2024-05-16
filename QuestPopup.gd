extends Control

var viewportWidth = get_viewport()



onready var questBackground = $TextureRect
onready var questLabel = $Label
onready var questNotificationLabel = get_node("Label")
onready var font = questNotificationLabel.get_font("font") as DynamicFont
onready var animation = get_node("AnimationPlayer")


func _ready():
	print("am i missing something", Global.quest_completed)
	if Global.quest_completed:
		playAnimation()
	else:
		print("ready to try")
		
func _process(delta):
	if Global.quest_completed:
		playAnimation()

func playAnimation():
	animation.play("GrowQuestPopUp")





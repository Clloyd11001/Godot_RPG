extends Area2D

export var QuestID: String

onready var questPopUp = get_node("CanvasLayer/QuestPopup")
onready var questPopUpLabel = get_node("CanvasLayer/QuestPopup/Label")
onready var popUpCamera = get_node("CanvasLayer/PopUpCamera")
onready var timer = get_node("Timer")

var hasQuestBeenCompleted = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _locationReached = self.connect("body_entered", self, "areaReached")
	timer.connect("timeout", self, "_on_Timer_timeout")

func areaReached(body):
	if !hasQuestBeenCompleted:
		if body.name == "Player":
			var arrayOfCompletedQuests = QuestSystem.completeQuest("MQ001")
			for i in arrayOfCompletedQuests.size():
				print("text of completed quest", arrayOfCompletedQuests[i])
				questPopUpLabel.text = "Player has completed the quest:" + arrayOfCompletedQuests[i]
				questPopUpLabel.set('theme_override_font_sizes/normal_font_size', 25)

				questPopUp.popup_centered()
				
				timer.start(4)
				set_process_input(false)
			QuestSystem.CompletedQuests = arrayOfCompletedQuests
			hasQuestBeenCompleted = true

func _on_Timer_timeout():
	# This method will be called when the timer emits the timeout signal
	questPopUp.hide()
	# Add any other actions you want to perform when the timer times out

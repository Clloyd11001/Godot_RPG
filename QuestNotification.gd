extends Panel

var level1_scene_path = "res://Level1.tscn"  

onready var questNotificationPanel = get_node(".")
onready var questNotificationLabel = get_node("HBoxContainer/QuestNotification")
onready var questNotificationLabel2 = get_node("HBoxContainer/QuestNotification2")

onready var activeQuestText = get_node("HBoxContainer2/ActiveQuestText")
onready var completedQuestText = get_node("HBoxContainer2/QuestCompletedText")

onready var questManager = get_node("QuestManager")

var localQuestName
# Called when the node enters the scene tree for the first time.
func _ready():
	print(questNotificationLabel2)
	showQuestNotification("MQ001")
	var font = questNotificationLabel.get_font("font")
	font.size = 2
	
	var _font2 = questNotificationLabel2.get_font("font")
	font.size = 2


func showQuestNotification(questName: String):
	localQuestName = questName
	questNotificationPanel.show()  
	var activeQuests = questManager.ActiveQuests
	
	if activeQuests.size() > 0:
		questNotificationLabel.text = "Quest Active\n" 
		questNotificationLabel2.text = "Quest Completed\n"
		activeQuestText.text = questName

func setCompletedQuestsText():
	# i have no idea why this questnotificationlabel2 never shows the text?!?!?
	# will fix later lmao
	completedQuestText.text = localQuestName
	questNotificationPanel.show()  

func _process(_delta):

	if QuestSystem.CompletedQuests.size() > 0:
		setCompletedQuestsText()
		activeQuestText.text = ""
	
	elif QuestSystem.CompletedQuests.size() <= 0:
		pass

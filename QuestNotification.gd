extends Panel

var level1_scene_path = "res://Level1.tscn"  

onready var questNotificationPanel = get_node(".")
onready var questNotificationLabel = get_node("QuestNotification")
onready var questNotificationLabel2 = get_node("QuestNotification2")
onready var questManager = get_node("QuestManager")

var localQuestName
# Called when the node enters the scene tree for the first time.
func _ready():
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
		questNotificationLabel.text = "Active Quests\n" + questName

func _process(_delta):

	if QuestSystem.CompletedQuests.size() > 0:
		setCompletedQuestsText()
	
	elif QuestSystem.CompletedQuests.size() <= 0:
		pass

func setCompletedQuestsText():
	# i have no idea why this questnotificationlabel2 never shows the text?!?!?
	# will fix later lmao
	questNotificationPanel.show()  
	questNotificationLabel2.text = localQuestName
	questNotificationLabel.text = "WAHOOO"

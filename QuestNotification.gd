extends Panel

var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly

onready var questNotificationPanel = get_node(".")
onready var questNotificationLabel = get_node("QuestNotification")
onready var questManager = get_node("QuestManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	showQuestNotification("MQ001")
	# changes the treewall font, but not the quest journal 
	# how??
	questNotificationLabel.get_font('font').size = 5

func showQuestNotification(questName: String):
	questNotificationPanel.show()  
	var activeQuests = questManager.ActiveQuests
	var completedQuests = questManager.CompletedQuests
	
	if activeQuests.size() > 0:
		questNotificationLabel.text = "Quest Active: " + "" + questName
		print('heres the quest', questName)
		questNotificationPanel.show() 

	elif completedQuests.size() > 0:
		questNotificationLabel.text = "Quest Completed: " + questName

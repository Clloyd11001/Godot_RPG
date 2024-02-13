extends Panel

var level1_scene_path = "res://Level1.tscn"  # Adjust the path accordingly

onready var questNotificationPanel = get_node(".")

onready var questNotificationLabel = get_node("QuestNotification")

onready var questManager = get_node("QuestManager")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	showQuestNotification("MQ001")

func _unhandled_input(event):
	if event.is_action_pressed("Quests"):
		Global.switch_to_scene(level1_scene_path)

func showQuestNotification(questName: String):
	questNotificationPanel.show()  # Assuming questNotificationPanel is the Panel node
	var activeQuests = questManager.ActiveQuests
	var completedQuests = questManager.CompletedQuests
	
	if activeQuests.size() > 0:
		questNotificationLabel.text = "Quest Active: " + questName
		questNotificationPanel.show()  # Assuming questNotificationPanel is the Panel node
	elif completedQuests.size() > 0:
		questNotificationLabel.text = "Quest Completed: " + questName

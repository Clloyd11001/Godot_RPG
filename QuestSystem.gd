extends Node


var Quests: Dictionary = {
	"MQ001":{
		"QuestName": "Show me Za Warudo",
		"CurrentStage": 0,
		"QuestDescription":{
			"10": "Stage 10 description"
		}
	},
	"MQ002":{
		"QuestName": "My newer quest name",
		"CurrentStage": 0,
		"QuestDescription":{
			"10": "Stage 10 newer description",
			"20": "Stage 20 newer description",
			"30": "Stage 30 newer description"
		}
	}
}

export var ActiveQuests : Dictionary = {}
export var CompletedQuests: Array = []

func addQuest(questID: String):
	if questID in ActiveQuests.keys():
		print("Quest with ID", questID, "is already in ActiveQuests.")
	elif questID in Quests.keys():
		ActiveQuests[questID] = Quests[questID]
	else:
		print("Error: Quest not found for questID", questID)

func advanceQuest(questID: String):
	if questID:
		if "CurrentStage" in ActiveQuests[questID]:
			ActiveQuests[questID]["CurrentStage"] += 10
#			var currentStage: String = str(ActiveQuests[questID]["CurrentStage"])
#			print(ActiveQuests)
#			if currentStage in ActiveQuests[questID]["QuestDescription"].keys():
#				print("Quest description:", ActiveQuests[questID]["QuestDescription"][currentStage])
#			else:
#				print("Warning: Attempted to advance non-existent questID", questID)
#		else:
#			print("Error: 'CurrentStage' not found for questID", questID)
	else:
		print("Error: questID not found in ActiveQuests")

func completeQuest(questID: String):
	# pop up to show completion
	print("questID", questID)
	print("active", ActiveQuests)
	if questID in ActiveQuests:
		CompletedQuests.append(ActiveQuests[questID]["QuestName"])
		var _erasedQuest = ActiveQuests.erase(questID)
		print("quest completed :)")
		print("completed quests", CompletedQuests)
	else:
		print("Error: questID not found in ActiveQuests")
		
	return CompletedQuests


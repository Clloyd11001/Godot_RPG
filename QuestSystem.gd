extends Node


var Quests: Dictionary = {
	"MQ001":{
		"QuestName": "My quest name",
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

var ActiveQuests : Dictionary = {}
var CompletedQuests: Array = []


func addQuest(questID: String):
	if questID in Quests.keys():
		ActiveQuests[questID] = Quests[questID]
		print("ID is in quests")
	else:
		print("Error: Quest not found for questID", questID)

func advanceQuest(questID: String):
	if questID in ActiveQuests:
		
		if "CurrentStage" in ActiveQuests[questID]:
			
			ActiveQuests[questID]["CurrentStage"] += 10
			var currentStage: String = str(ActiveQuests[questID]["CurrentStage"])

			if currentStage in ActiveQuests[questID]["QuestDescription"].keys():
				print("Quest description:", ActiveQuests[questID]["QuestDescription"][currentStage])

			else:
				print("Warning: Attempted to advance non-existent questID", questID)

func completeQuest(questID: String):
	print("First ActiveQuests:", ActiveQuests)
	if questID in ActiveQuests:
		CompletedQuests.append(ActiveQuests[questID]["QuestName"])
		ActiveQuests.erase(questID)
		print("Quest Completed", CompletedQuests)
		# Print the final state of ActiveQuests after the function call
		print("Final ActiveQuests:", ActiveQuests)
	else:
		print("Error: questID not found in ActiveQuests")

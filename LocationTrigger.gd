extends Area2D

export var QuestID: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", self, "areaReached")

func areaReached(body):
	if body.name == "Player":
		QuestSystem.completeQuest(QuestID)
		#self.queue_free()

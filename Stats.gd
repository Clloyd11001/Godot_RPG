extends Node


export var max_health = 4 setget set_max_health

export var allotedUpgradePoints = 0

# Allows you to change in editor without overriding variable
# Setget calls back every time health is set
var health = max_health setget set_health

# CHARACTER STATS
export (int) var MAX_HP = 12
export (int) var STRENGTH = 8
export (int) var MANA = 1
export (int) var level = 1

signal health_changed(value)
signal max_health_changed(value)

onready var loading = get_node("/root/Loading")


func set_max_health(value):
	max_health = value
	self.health = min(health,max_health)
	emit_signal("max_health_changed")
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
		
		#loading.load_scene(self, "res://GameOver.tscn")


func _ready():
	self.health = max_health
	
	

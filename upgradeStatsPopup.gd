extends Popup

onready var healthStat = get_node("CanvasLayer/HealthStat")
onready var attackStat = get_node("CanvasLayer/AttackStat")
onready var manaStat = get_node("CanvasLayer/ManaStat")
onready var playerNode = get_parent()

var healthChanges = 0
var attackChanges = 0
var manaChanges = 0

var skillsToBeSubmitted = []
var allotedUpgradePoints = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Alloted Upgrade Points:", PlayerStats.allotedUpgradePoints)
	update_stats()
# for adding health
func _on_Button_pressed():
	if PlayerStats.allotedUpgradePoints > 0:
		PlayerStats.MAX_HP += 1
		PlayerStats.allotedUpgradePoints -= 1
		
# for subtracting health
func _on_Button2_pressed():
	if healthChanges > 0:
		PlayerStats.MAX_HP -= 1
		PlayerStats.allotedUpgradePoints -= 1

func _on_AttackButtonPlus_pressed():
	if PlayerStats.allotedUpgradePoints > 0:
		PlayerStats.STRENGTH += 1
		PlayerStats.allotedUpgradePoints -= 1

func _on_AttackButtonMinus_pressed():
	if attackChanges > 0:
		PlayerStats.STRENGTH -= 1
		PlayerStats.allotedUpgradePoints -= 1

func _on_ManaButtonPlus_pressed():
	if PlayerStats.allotedUpgradePoints > 0:
		PlayerStats.MANA += 1
		PlayerStats.allotedUpgradePoints -= 1

func _on_ManaButtonMinus_pressed():
	if manaChanges > 0:
		PlayerStats.MANA -= 1
		PlayerStats.allotedUpgradePoints -= 1

func update_stats():
	healthStat.text = "Health: " + str(PlayerStats.MAX_HP + healthChanges)
	attackStat.text = "Attack: " + str(PlayerStats.STRENGTH + attackChanges)
	manaStat.text = "Mana: " + str(PlayerStats.MANA + manaChanges)

func _on_Submit_pressed():
	playerNode.enable_input()
	if PlayerStats.allotedUpgradePoints == 0:
		print("Alloted Upgrade Points:", PlayerStats.allotedUpgradePoints)
		apply_changes()
	
	
func apply_changes():
	PlayerStats.MAX_HP += healthChanges
	PlayerStats.STRENGTH += attackChanges
	PlayerStats.MANA += manaChanges

	# Reset changes
	healthChanges = 0
	attackChanges = 0
	manaChanges = 0

	# Update displayed stats
	update_stats()

func _process(_delta):
	healthStat.text = "Health: " + str(PlayerStats.MAX_HP)
	attackStat.text = "Attack: " + str(PlayerStats.STRENGTH)
	manaStat.text = "Mana: " + str(PlayerStats.MANA)

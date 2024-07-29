extends AnimatedSprite

signal starting_bomb_toss
onready var goblin = get_parent()
onready var goblinAnimations = goblin.get_node("AnimatedSprite")
onready var detectPlayer = goblin.get_node("PlayerDetectionZone")
var throwBomb = false

## Called when the node enters the scene tree for the first time.
func _ready():
	goblinAnimations.play("idle")

func _process(delta):
	if throwBomb:
		goblinAnimations.play("throwBomb")
	
func _on_PlayerDetectionZone_body_entered(body):
	throwBomb = true

	emit_signal("starting_bomb_toss")
	

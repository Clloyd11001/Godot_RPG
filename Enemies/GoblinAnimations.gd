extends AnimatedSprite

signal starting_bomb_toss
onready var goblin = get_parent()
onready var goblinAnimations = goblin.get_node("AnimatedSprite")
onready var detectPlayer = goblin.get_node("PlayerDetectionZone")

## Called when the node enters the scene tree for the first time.
func _ready():
	goblinAnimations.play("idle")


## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
#
func _on_PlayerDetectionZone_body_entered(body):
	goblinAnimations.play("throwBomb")
	emit_signal("starting_bomb_toss")

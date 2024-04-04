extends Control

#signal screen_changed
onready var loading = get_node("/root/Loading")

onready var background = get_node("TextureRect")
onready var background2 = get_node("TextureRect2")
onready var background3 = get_node("TextureRect3")
onready var background4 = get_node("TextureRect4")
onready var background5 = get_node("TextureRect5")
onready var background6 = get_node("TextureRect6")
onready var background7 = get_node("TextureRect7")
onready var background8 = get_node("TextureRect8")
onready var background9 = get_node("TextureRect9")
onready var background10 = get_node("TextureRect10")
onready var background11 = get_node("TextureRect11")
onready var background12 = get_node("TextureRect12")
onready var animation = get_node("AnimationPlayer")
#questBackground.set_size(get_viewport_rect().size, true) 
#questLabel.set_size(get_viewport_rect().size, true) 
func _ready():
	animation.play("Idle_Screen")
	

func _on_Play_pressed():
	#print("pressed play")
	#var _play = get_tree().change_scene("res://TreeWall.tscn")
	loading.load_scene(self, "res://TreeWall.tscn")
	Global.update_scene('TreeWall')
	
func _on_Options_pressed():
	#print("pressed option")
	var _optionsMenu = get_tree().change_scene("res://Options_Menu.tscn")


func _on_Quit_pressed():
	#print("pressed quit")
	get_tree().quit()

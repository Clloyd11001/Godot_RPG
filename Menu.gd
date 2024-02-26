extends Control

signal screen_changed
onready var loading = get_node("/root/Loading")

func _on_Play_pressed():
	#print("pressed play")
	#var _play = get_tree().change_scene("res://TreeWall.tscn")
	loading.load_scene(self, "res://TreeWall.tscn")
	
func _on_Options_pressed():
	#print("pressed option")
	var _optionsMenu = get_tree().change_scene("res://Options_Menu.tscn")


func _on_Quit_pressed():
	#print("pressed quit")
	get_tree().quit()

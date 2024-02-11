extends Control



func _on_Play_pressed():
	#print("pressed play")
	get_tree().change_scene("res://TreeWall.tscn")

func _on_Options_pressed():
	#print("pressed option")
	get_tree().change_scene("res://Options_Menu.tscn")


func _on_Quit_pressed():
	#print("pressed quit")
	get_tree().quit()

extends Control



func _on_Play_pressed():
	get_tree().change_scene("res://Level1.tscn")

func _on_Options_pressed():
	get_tree().change_scene("res://Options_Menu.tscn")


func _on_Quit_pressed():
	get_tree().quit()

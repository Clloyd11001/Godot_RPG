extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")


func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	var _world = get_tree().current_scene
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position


func drop_object_from_grass() -> void:
	var potion =  get_node("Potion")
	if potion:
		potion.visible = true
	if potion.visible == true:
		var tween:Tween = get_node("Tween")
		if potion and tween:

			var drop_distance = 2
			
			var drop_tween = tween.interpolate_property(potion, "position", potion.position, potion.position + Vector2(0, drop_distance), 0.3, Tween.TRANS_QUAD,
									   Tween.EASE_OUT)
			
			var rise_tween = tween.interpolate_property(potion, "position", potion.position + Vector2(0, drop_distance), potion.position, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN, 0.5)
			
			tween.start()

			yield(tween, "tween_completed")

func _on_HurtBox_area_entered(area):
	var grass_node = get_node("Sprite")
	create_grass_effect()
	grass_node.visible = false
	drop_object_from_grass()

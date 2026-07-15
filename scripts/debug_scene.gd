extends Node2D

func _on_gamescreen_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay_holder.tscn")

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Stage_1.disabled = true
	$Stage_2.disabled = true
	$Stage_3.disabled = true
	if PlayerStats.completed_rounds % 3 == 0:
		$Stage_1.disabled = false
	elif PlayerStats.completed_rounds % 3 == 1:
		$Stage_2.disabled = false
	else:
		$Stage_3.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_stage_1_pressed() -> void:
	PlayerStats.target_this_round = 300
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")


func _on_stage_2_pressed() -> void:
	PlayerStats.target_this_round = 450
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")


func _on_stage_3_pressed() -> void:
	PlayerStats.target_this_round = 600
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")

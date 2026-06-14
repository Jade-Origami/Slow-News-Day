extends Node2D


var level_mult
var round_1_required : int
var round_2_required : int
var round_3_required : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("integer_division")
	var completed_levels = floor(PlayerStats.completed_rounds / 3)
	level_mult = completed_levels + 0.5
	round_1_required = 200 * level_mult
	round_2_required = 300 * level_mult
	round_3_required = 400 * level_mult
	$Panel/Stage_1.disabled = true
	$Panel/Stage_2.disabled = true
	$Panel/Stage_3.disabled = true
	if PlayerStats.completed_rounds % 3 == 0:
		$Panel/Stage_1.disabled = false
	elif PlayerStats.completed_rounds % 3 == 1:
		$Panel/Stage_2.disabled = false
	else:
		$Panel/Stage_3.disabled = false
	$Panel/Stage_1.text = "Round 1:\n" + str(round_1_required) + " points"
	$Panel/Stage_2.text = "Round 2:\n" + str(round_2_required) + " points"
	$Panel/Stage_3.text = "Round 3:\n" + str(round_3_required) + " points"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_stage_1_pressed() -> void:
	PlayerStats.target_this_round = round_1_required
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")


func _on_stage_2_pressed() -> void:
	PlayerStats.target_this_round = round_2_required
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")


func _on_stage_3_pressed() -> void:
	PlayerStats.target_this_round = round_3_required
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")

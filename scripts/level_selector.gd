extends Panel


var level_mult
var level_requirements = [100, 300, 800, 2000, 5000, 11000, 20000, 35000, 50000]
var round_1_required : int
var round_2_required : int
var round_3_required : int
var round_reward : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_gameplay_holder_level_select()


func _on_stage_1_pressed() -> void:
	PlayerStats.target_this_round = round_1_required
	round_reward = 3
	$"..".initiate_round(round_reward)


func _on_stage_2_pressed() -> void:
	PlayerStats.target_this_round = round_2_required
	round_reward = 4
	$"..".initiate_round(round_reward)


func _on_stage_3_pressed() -> void:
	PlayerStats.target_this_round = round_3_required
	round_reward = 5
	$"..".initiate_round(round_reward)


func _on_gameplay_holder_level_select() -> void:
	@warning_ignore("integer_division")
	var level_num = floor(PlayerStats.completed_rounds / 3) + 1
	round_1_required = level_requirements[level_num]
	round_2_required = level_requirements[level_num] * 1.5
	round_3_required = level_requirements[level_num] * 2
	$Stage_1.disabled = true
	$Stage_2.disabled = true
	$Stage_3.disabled = true
	if PlayerStats.completed_rounds % 3 == 0:
		$Stage_1.disabled = false
	elif PlayerStats.completed_rounds % 3 == 1:
		$Stage_2.disabled = false
	else:
		$Stage_3.disabled = false
	$Stage_1.text = "Round 1:\n" + str(round_1_required) + " points"
	$Stage_2.text = "Round 2:\n" + str(round_2_required) + " points"
	$Stage_3.text = "Round 3:\n" + str(round_3_required) + " points"

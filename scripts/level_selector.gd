extends Panel


var level_mult
var level_requirements = [100, 300, 800, 2000, 5000, 11000, 20000, 35000, 50000]
var round_1_required : int
var round_2_required : int
var round_3_required : int
var round_reward : int
var boss_this_level
var level_num
var shown = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_gameplay_holder_level_select()


func _on_stage_1_pressed() -> void:
	PlayerStats.target_this_round = round_1_required
	round_reward = 3
	$"..".initiate_round(round_reward, null)


func _on_stage_2_pressed() -> void:
	PlayerStats.target_this_round = round_2_required
	round_reward = 4
	$"..".initiate_round(round_reward, null)


func _on_stage_3_pressed() -> void:
	PlayerStats.target_this_round = round_3_required
	round_reward = 5
	$"..".initiate_round(round_reward, boss_this_level) #boss round!


func _on_gameplay_holder_level_select() -> void:
	@warning_ignore("integer_division")
	level_num = floor(PlayerStats.completed_rounds / 3) + 1
	
	$Stage_1.disabled = true
	$Stage_2.disabled = true
	$Stage_3.disabled = true
	
	if PlayerStats.completed_rounds % 3 == 0:
		if level_num <= 8:
			start_level_normal()
		elif level_num == 9:
			trigger_win_screen()
		else:
			start_level_endless()
		$Stage_1.disabled = false
	elif PlayerStats.completed_rounds % 3 == 1:
		$Stage_2.disabled = false
	else:
		$Stage_3.disabled = false

func start_level_normal():
	$Level_Read.text = "Level:\n" + str(level_num) + "/8"
	
	boss_this_level = select_boss_effect()
	
	round_1_required = level_requirements[level_num]
	round_2_required = level_requirements[level_num] * 1.5
	round_3_required = level_requirements[level_num] * 2 * boss_this_level.score_effect
	
	$Stage_1.text = "Round 1:\n" + str(round_1_required) + " points"
	$Stage_2.text = "Round 2:\n" + str(round_2_required) + " points"
	$Stage_3.text = "Round 3:\n" + str(round_3_required) + " points"
	
	$Stage_3/Panel/Effect.text = "Boss Effect:\n" + boss_this_level.pretty_text

func start_level_endless():
	$Level_Read.text = "Level:\n" + str(level_num)
	
	boss_this_level = select_boss_effect()
	
	var endless_level_requirement = level_num * 7754
	round_1_required = endless_level_requirement
	round_2_required = endless_level_requirement * 1.5
	round_3_required = endless_level_requirement * 2 * boss_this_level.score_effect
	
	$Stage_1.text = "Round 1:\n" + str(round_1_required) + " points"
	$Stage_2.text = "Round 2:\n" + str(round_2_required) + " points"
	$Stage_3.text = "Round 3:\n" + str(round_3_required) + " points"
	
	$Stage_3/Panel/Effect.text = "Boss Effect:\n" + boss_this_level.pretty_text


func select_boss_effect():
	var boss_effects = [
		{
			"pretty_text": "Vowels don't count",
			"id": "no_vowels",
			"trigger_time": "on_type",
			"score_effect": 0.5
		},
		{
			"pretty_text": "Less time per story",
			"id": "less_time",
			"trigger_time": "affect_sentence",
			"score_effect": 1
		},
		{
			"pretty_text": "Two Stories",
			"id": "double_story",
			"trigger_time": "affect_sentence",
			"score_effect": 2
		},
		{
			"pretty_text": "No WC for completed words",
			"id": "no_mult_space",
			"trigger_time": "on_type",
			"score_effect": 1
		},
		{
			"pretty_text": "Extra-high required score",
			"id": "high_required",
			"trigger_time": "none",
			"score_effect": 2.75
		},
		{
			"pretty_text": "Left third of keyboard doesn't count",
			"id": "no_left",
			"trigger_time": "on_type",
			"score_effect": 0.75
		},
		{
			"pretty_text": "Centre third of keyboard doesn't count",
			"id": "no_centre",
			"trigger_time": "on_type",
			"score_effect": 0.75
		},
		{
			"pretty_text": "Right third of keyboard doesn't count",
			"id": "no_right",
			"trigger_time": "on_type",
			"score_effect": 0.75
		},
	]
	return boss_effects.pick_random()


func _on_gameplay_holder_show_level_select() -> void:
	$Stage_1.disabled = true
	$Stage_2.disabled = true
	$Stage_3.disabled = true
	show()


func trigger_win_screen():
	pass

extends Node


var sentence_left
var mistakes_made = 0
var time_passed = 0
var timer_active = false
var is_first_letter = true
var max_timer_value : int
var multiple_coin : String
var palette
var round_total : int
var player_total : int
var sentence_already_filled
var used_predictive = false
var base = 1
var mult = 1
var total_score = 0
var sentences_used = 0
var percentage_of_time = 0
var double_speed_amount = 0
var typed_letter = ""
var reroll_amount = 1
var total_rerolls
var can_tab_to_fill = false
var mistake_overlay_timer = 0
var coin_round_reward : int
var set_before_round_active_upgrades = [null, null, null, null]
var letter_to_be_typed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Mistake_Overlay.hide()
	$"../Panels/Timer_bar/Coins_Rotate/Coins_Counter".text = "£" + str(PlayerStats.coins)


func timer_increment() -> void:
	time_passed += 1
	$"../Panels/Timer_bar".value = time_passed
	percentage_of_time = 1.25 - snapped((float(time_passed) / max_timer_value), 0.01)
	$"../Panels/Timer_bar/Timer/Text".text = str(percentage_of_time)
	if time_passed >= max_timer_value:
		timer_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer_active:
		timer_increment()
		if double_speed_amount > 0:
			double_speed_amount -= 1
			timer_increment()
	if mistake_overlay_timer > 0:
		$Mistake_Overlay.show()
		mistake_overlay_timer -= 1
	else:
		$Mistake_Overlay.hide()


func _on_sentence_take_text_changed(new_text: String) -> void:
	if !timer_active:
		timer_active = true
		$Rotate_Discard/Discard_Button.hide()
		change_upgrades_that_change()
	
	letter_to_be_typed = sentence_left[0].to_lower()
	typed_letter = new_text[-1].to_lower()
	
	var space_char = " "
	if is_upgrade_present("ignore_mistakes"):
		space_char = "_"
		if letter_to_be_typed == "_":
			letter_to_be_typed = " "
	
	if typed_letter == letter_to_be_typed:
		sentence_left = sentence_left.substr(1,-1)
		
		base += 1
		$"../Panels/Timer_bar/Base_Rotate".agitate()
		
		if typed_letter.to_lower() == " ": #When word finished
			mult += 1
			$"../Panels/Timer_bar/Mult_Rotate".agitate()
		
		check_upgrades("on_type")
		
		$"../Panels/Timer_bar/Base_Rotate/Base/Text".text = str(base)
		$"../Panels/Timer_bar/Mult_Rotate/Mult/Text".text = str(mult)
		
		if space_char ==  "_" and typed_letter == " ":
			typed_letter = "_"
		
		sentence_already_filled += ("[color=%s]" % palette.completed_text) + typed_letter + ("[/color][color=%s]" % palette.other_text)
		$Gameplay/SentenceShow.text = sentence_already_filled + sentence_left + "!" 
		$Gameplay/TypingProgress.value += 1
	else: #Mistake has been made
		mistakes_made += 1
		double_speed_amount = 40
		check_upgrades("mistake_made")
		$Gameplay.agitate()
		mistake_overlay_timer = 15
	
	if sentence_left.is_empty(): #Sentence has been finished
		check_upgrades("sentence_end")
		sentence_finished()


func sentence_finished() -> void:
	sentences_used += 1
	$"../Panels/Timer_bar/Hands_Rotate".agitate()
	timer_active = false
	is_first_letter = false
	
	var score_this_sentence = int(floor((base * mult) * percentage_of_time)) + 10
	if score_this_sentence < 10:
		score_this_sentence = 10
	total_score += score_this_sentence
	var multiple_mistakes
	if mistakes_made == 1:
		multiple_mistakes = "mistake"
	else:
		multiple_mistakes = "mistakes"
	$Gameplay.rotation_degrees = 0
	$Gameplay/SentenceShow.text = "Round clear!
You made " + str(mistakes_made) + " " + multiple_mistakes +"
score: " + str(score_this_sentence)
	$"../Panels/Timer_bar/TotalScore/Rotate".agitate()
	refresh_Score_Panel()
	if total_score >= PlayerStats.target_this_round:
		round_finished()
	elif sentences_used >= PlayerStats.sentences_allowed:
		$Gameplay/SentenceShow.text = "Game over \nPlease restart the game"
	else:
		$Rotate_Discard/Discard_Button.hide()
		$Rotate_Discard/Next_Button.show()


func sentence_start():
	Sentences.correct_sentence = Sentences.create_sentence(is_upgrade_present("ignore_mistakes"))
	Sentences.correct_sentence = Sentences.correct_sentence.left(-1)
	sentence_left = Sentences.correct_sentence
	$Gameplay/TypingProgress.max_value = Sentences.correct_sentence.length()
	$Gameplay/SentenceShow.text = ("[color=%s]" % palette.other_text) + Sentences.correct_sentence + "!"
	max_timer_value = int(Sentences.correct_sentence.length() * 23)
	$"../Panels/Timer_bar".max_value = max_timer_value
	$Gameplay.rotation_degrees = randi_range(-25, 25)
	
	sentence_already_filled = ""
	time_passed = 0
	$"../Panels/Timer_bar".value = time_passed
	$Gameplay/TypingProgress.value = 0
	base = 1
	mult = 1
	$"../Panels/Timer_bar/Base_Rotate/Base/Text".text = str(base)
	$"../Panels/Timer_bar/Mult_Rotate/Mult/Text".text = str(mult)
	$"../Panels/Timer_bar/Timer/Text".text = str(1.25)
	$Rotate_Discard/Next_Button.hide()
	$Rotate_Discard/Discard_Button.hide()
	if reroll_amount > 0:
		$Rotate_Discard/Discard_Button.show()
	mistakes_made = 0
	is_first_letter = true
	refresh_Score_Panel()
	check_upgrades("sentence_start")


func round_finished() -> void:
	PlayerStats.completed_rounds += 1
	$Gameplay/TypingProgress.value = 0
	reward_screen()


func reward_screen():
	$"..".initiate_reward_screen(calculate_rewards(), (PlayerStats.sentences_allowed - sentences_used))
	refresh_Score_Panel()


func calculate_rewards():
	var coins_increase = ((4 - sentences_used) * 1) + coin_round_reward
	if coins_increase < 1:
		coins_increase = 1
	return coins_increase


func apply_styling() -> void:
	palette = PlayerStats.palettes.pick_random()
	$"../Background".color = palette.background
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = Color(palette.completed_text)
	$Gameplay/TypingProgress.add_theme_stylebox_override("fill", bar_fill)


func _on_discard_button_pressed() -> void:
	if reroll_amount > 0:
		reroll_amount -= 1
		$Rotate_Discard/Discard_Button.text = "Reroll (" + str(reroll_amount) + "/" + str(total_rerolls) + ")"
		if reroll_amount <= 0:
			$Rotate_Discard/Discard_Button.hide()
		$Rotate_Discard.agitate()
		$Gameplay.agitate()
		sentence_start()


func get_word_start_index(text: String, char_index: int) -> int:
	# Find the last space before char_index
	var last_space: int = -1
	for i in range(char_index):
		if text[i] == ' ':
			last_space = i
	return last_space + 1


func tab_autofill() -> void:
	if can_tab_to_fill:
		can_tab_to_fill = false
		var index_currently_typed = sentence_already_filled.length() - 1
		var index_of_word = get_word_start_index(Sentences.correct_sentence, index_currently_typed)
		var length_of_containing_word = 0
		var index_helper = index_of_word
		while Sentences.correct_sentence[index_helper] != " " and index_helper != (Sentences.correct_sentence.length()-1):
			index_helper += 1
			length_of_containing_word += 1
		sentence_left = sentence_left.substr((length_of_containing_word - (index_currently_typed - index_of_word)),-1)
		sentence_already_filled = Sentences.correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/TypingProgress.value += (length_of_containing_word - (index_currently_typed - index_of_word))
		$Gameplay/SentenceShow.text = ("[color=%s]" % palette.completed_text) + sentence_already_filled + ("[/color][color=%s]" % palette.other_text) + sentence_left + "!" 
		if sentence_left.is_empty():
			sentence_finished()


func _on_next_button_pressed() -> void:
	sentence_start()


func _on_gameplay_holder_new_round(round_reward) -> void:
	coin_round_reward = round_reward
	total_score = 0
	sentences_used = 0
	apply_styling()
	#$"../Panel/ShopButton".hide()
	$"../Panels/Timer_bar/TotalScore/Rotate".agitate()
	refresh_Score_Panel()
	$"../Panels/Timer_bar/RequiredScore/Rotate/ScoreArea/ScoreRead".text = str(PlayerStats.target_this_round)
	reroll_amount = 1
	check_upgrades("round_start")
	total_rerolls = reroll_amount
	$Rotate_Discard/Discard_Button.text = "Reroll (" + str(reroll_amount) + "/" + str(total_rerolls) + ")"
	sentence_start()


func upgrade_apply(upgrade):
	if upgrade.id == "a_upgrade":
		if typed_letter.to_lower() == "a":
			mult += 2
			base += 2
			$"../Panels/Timer_bar/Mult_Rotate".agitate()
			return true
	
	elif upgrade.id == "flat_coin_increase":
		$"../Reward_Panel/MoneySources".text += "\nHigher Wages: £2"
		$"../Reward_Panel".total_to_give += 2
		return true
	
	elif upgrade.id == "double_letters_bypass":
		if sentence_left == "": #prevents overstepping index
			pass
		elif typed_letter == sentence_left[0].to_lower(): #if current letter is also next letter
			mult += 2
			sentence_left = sentence_left.substr(1,-1)
			$Gameplay/TypingProgress.value += 1
			check_upgrades("on_type", upgrade.id)
			return true
	
	elif upgrade.id == "s_upgrade":
		if typed_letter.to_lower() == "s":
			mult = snapped((mult  * 1.25), 1)
			return true
	
	elif upgrade.id == "mistake_penalty":
		double_speed_amount *= 0.75
		return true
	
	elif upgrade.id == "round_time_increase":
		max_timer_value = snapped((max_timer_value * 1.25), 1)
		$"../Panels/Timer_bar".max_value = max_timer_value
		return true
	
	elif upgrade.id == "reroll_sentence":
		reroll_amount += 2
		return true
	
	elif upgrade.id == "tab_to_fill":
		can_tab_to_fill = true
		return true
	
	elif upgrade.id == "z_upgrade":
		if typed_letter.to_lower() == "z":
			mult *= 2
			return true
	
	elif upgrade.id == "flat_mult":
		mult += 4
		$"../Panels/Timer_bar/Mult_Rotate".agitate()
		refresh_Score_Panel()
		return true
	
	
	elif upgrade.id == "empty_slot":
		var amount_empty = 0
		for i in range(set_before_round_active_upgrades.size()):
			if set_before_round_active_upgrades[i] == null:
				amount_empty += 1
			elif set_before_round_active_upgrades[i].id == "empty_slot":
				amount_empty += 1
		var mult_mult = 1.5 * amount_empty
		mult = snapped((mult * mult_mult), 1)
		refresh_Score_Panel()
		return true
	
	elif upgrade.id == "shop_surplus":
		$"../ShopScene".extra_item = true
		return true
	
	elif upgrade.id == "ignore_mistakes":
		sentence_left = sentence_left.substr(1,-1)
		var mistake_print = letter_to_be_typed
		if mistake_print == " ":
			mistake_print = "_"
		sentence_already_filled += "[color=red]" + mistake_print + ("[/color][color=%s]" % palette.other_text)
		$Gameplay/SentenceShow.text = sentence_already_filled + sentence_left + "!" 
		$Gameplay/TypingProgress.value += 1
		double_speed_amount -= 10
		return true
	
	else:
		return false


func check_upgrades(time, bypass = null):
	for i in range(set_before_round_active_upgrades.size()):
		var upgrade = set_before_round_active_upgrades[i]
		if upgrade == null:
			pass
		elif upgrade.id == bypass:
			pass
		elif upgrade.trigger_time == time:
			if upgrade_apply(upgrade): #upgrade applies
				if i == 0:
					$"../Panels/Upgrades_Panel/Rotate_Item_1".agitate()
				elif i == 1:
					$"../Panels/Upgrades_Panel/Rotate_Item_2".agitate()
				elif i == 2:
					$"../Panels/Upgrades_Panel/Rotate_Item_3".agitate()
				elif i == 3:
					$"../Panels/Upgrades_Panel/Rotate_Item_4".agitate()


func is_upgrade_present(itemid):
	for i in range($"../Panels/Upgrades_Panel".active_upgrades.size()):
		if $"../Panels/Upgrades_Panel".active_upgrades[i] == null:
			pass
		elif $"../Panels/Upgrades_Panel".active_upgrades[i].id == itemid:
			return true
	return false


func furthest_non_null_index(arr: Array) -> int:
	for i in range(arr.size() - 1, -1, -1):
		if arr[i] != null:
			return i
	return -1


func change_upgrades_that_change():
	set_before_round_active_upgrades = $"../Panels/Upgrades_Panel".active_upgrades.duplicate(true) #stop upgrades from being rearranged during round
	for i in range(set_before_round_active_upgrades.size()):
		change_specific_upgrade(i)


func change_specific_upgrade(pos):
	var upgrade = set_before_round_active_upgrades[pos]
	if upgrade == null:
		pass
	elif upgrade.id == "copy_above":
		if pos == 0:
			pass
		else:
			var one_above = pos-1
			if set_before_round_active_upgrades[one_above].trigger_time == "changes":
				change_specific_upgrade(one_above)
			upgrade.id = set_before_round_active_upgrades[one_above].id
			upgrade.trigger_time = set_before_round_active_upgrades[one_above].trigger_time
		
	elif upgrade.id == "copy_bottom":
		var furthest_non_null = 0
		furthest_non_null = furthest_non_null_index(set_before_round_active_upgrades)
		if set_before_round_active_upgrades[furthest_non_null].trigger_time == "changes":
				change_specific_upgrade(furthest_non_null)
		upgrade.id = set_before_round_active_upgrades[furthest_non_null].id
		upgrade.trigger_time = set_before_round_active_upgrades[furthest_non_null].trigger_time


func refresh_Score_Panel(): 
	$"../Panels/Timer_bar/TotalScore/Rotate/ScoreArea/ScoreRead".text = str(total_score)
	$"../Panels/Timer_bar/Base_Rotate/Base/Text".text = str(base)
	$"../Panels/Timer_bar/Mult_Rotate/Mult/Text".text = str(mult)
	$"../Panels/Timer_bar/Hands_Rotate/Hands_Counter".text = str(sentences_used) + " / " + str(PlayerStats.sentences_allowed)

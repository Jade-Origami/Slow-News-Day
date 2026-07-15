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
var can_tab_to_fill
var mistake_overlay_timer = 0
var coin_round_reward : int
var set_before_round_active_upgrades = [null, null, null, null]
var letter_to_be_typed
var boss_effect = null
var i_score


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
		
		set_before_round_active_upgrades = $"../Panels/Upgrades_Panel".active_upgrades.duplicate(true) #stop upgrades from being rearranged during round
		
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
		
		if boss_effect != null and check_boss_debuff("on_type"):
			boss_debuffs()
		else:
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
		set_SentenceShow_text(sentence_already_filled + sentence_left) 
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
	if boss_effect == null:
		$Gameplay/Boss_Effect_Rotate/Boss_Effect.hide()
		Sentences.correct_sentence = Sentences.create_sentence(is_upgrade_present("ignore_mistakes"))
	else: #boss round!
		$Gameplay/Boss_Effect_Rotate/Boss_Effect.show()
		$Gameplay/Boss_Effect_Rotate/Boss_Effect.text = "[b][color=black]BOSS ROUND:[/color][/b]\n" + boss_effect.pretty_text
		Sentences.correct_sentence = Sentences.create_boss_sentence()
	Sentences.correct_sentence = Sentences.correct_sentence.left(-1)
	
	if boss_effect != null and check_boss_debuff("affect_sentence"):
		boss_debuffs()
	
	sentence_left = Sentences.correct_sentence
	$Gameplay/TypingProgress.max_value = Sentences.correct_sentence.length()
	set_SentenceShow_text(("[color=%s]" % palette.other_text) + sentence_left)
	max_timer_value = int(Sentences.correct_sentence.length() * 23)
	$"../Panels/Timer_bar".max_value = max_timer_value
	$Gameplay.rotation_degrees = randi_range(-25, 25)
	
	if boss_effect != null and check_boss_debuff("sentence_start"):
		boss_debuffs()
	
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
	set_before_round_active_upgrades = $"../Panels/Upgrades_Panel".active_upgrades
	check_upgrades("sentence_start")
	refresh_Score_Panel()
	


func round_finished() -> void:
	PlayerStats.completed_rounds += 1
	$Gameplay/TypingProgress.value = 0
	i_score = 0
	reward_screen()


func reward_screen():
	$"..".initiate_reward_screen(coin_round_reward, (PlayerStats.sentences_allowed - sentences_used))
	refresh_Score_Panel()


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


func tab_autofill() -> void:
	if can_tab_to_fill:
		var index_of_typed = strip_bbcode(sentence_already_filled).length()
		var end_index_of_word = index_of_typed 
		while end_index_of_word < Sentences.correct_sentence.length() and Sentences.correct_sentence[end_index_of_word] != " ":
			end_index_of_word += 1
		var rest_of_word = Sentences.correct_sentence.substr(index_of_typed, (end_index_of_word - index_of_typed))
		
		sentence_left = Sentences.correct_sentence.substr(end_index_of_word,-1)
		sentence_already_filled += ("[color=%s]" % palette.completed_text) + rest_of_word + ("[/color][color=%s]" % palette.other_text)
		set_SentenceShow_text(sentence_already_filled + sentence_left)
		$Gameplay/TypingProgress.value += rest_of_word.length()
		
		can_tab_to_fill = false
		
		if sentence_left.is_empty(): #Sentence has been finished
			check_upgrades("sentence_end")
			sentence_finished()


func strip_bbcode(source: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)


func _on_gameplay_holder_new_round(round_reward, boss_round_effect = null) -> void:
	boss_effect = boss_round_effect
	coin_round_reward = round_reward
	total_score = 0
	sentences_used = 0
	apply_styling()
	$"../Panels/Timer_bar/TotalScore/Rotate".agitate()
	$"../Panels/Timer_bar/RequiredScore/Rotate/ScoreArea/ScoreRead".text = str(PlayerStats.target_this_round)
	reroll_amount = 1
	set_before_round_active_upgrades = $"../Panels/Upgrades_Panel".active_upgrades
	can_tab_to_fill = false
	check_upgrades("round_start")
	total_rerolls = reroll_amount
	$Rotate_Discard/Discard_Button.text = "Reroll (" + str(reroll_amount) + "/" + str(total_rerolls) + ")"
	refresh_Score_Panel()
	sentence_start()


func upgrade_apply(upgrade, typed_bypass = false):
	if upgrade.id == "a_upgrade":
		if typed_letter.to_lower() == "a" or typed_bypass:
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
			mult += 6
			sentence_already_filled += ("[color=brown]") + sentence_left[0].to_lower() + ("[/color][color=%s]" % palette.other_text)
			sentence_left = sentence_left.substr(1,-1)
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
		set_SentenceShow_text(sentence_already_filled + sentence_left)
		$Gameplay/TypingProgress.value += 1
		double_speed_amount -= 10
		return true
	
	elif upgrade.id == "e_upgrade":
		if typed_letter.to_lower() == "e" or typed_bypass:
			base += 10
			return true
	
	elif upgrade.id == "count_upgrade":
		var total_upgrades = 0
		for i in range(set_before_round_active_upgrades.size()):
			if set_before_round_active_upgrades[i] != null:
				total_upgrades += 1
		mult += total_upgrades * 3
		return true
	
	elif upgrade.id == "i_upgrade":
		if typed_letter.to_lower() == "i" or typed_bypass:
			i_score += 1
			mult += i_score
			$"../Panels/Timer_bar/Mult_Rotate".agitate()
			refresh_Score_Panel()
			return true
	
	elif upgrade.id == "y_upgrade":
		if typed_letter.to_lower() == "y":
			check_upgrades("on_type", "y_upgrade", true)
			return true
	
	else:
		return false


func check_upgrades(time, bypass = null, typed_bypass = false):
	for i in range(set_before_round_active_upgrades.size()):
		var upgrade = set_before_round_active_upgrades[i]
		if upgrade == null:
			pass
		elif upgrade.id == bypass:
			pass
		elif upgrade.trigger_time == time:
			if upgrade_apply(upgrade, typed_bypass): #upgrade applies
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


func boss_debuffs():
	var trigger_agitation = false
	if boss_effect.id == "no_vowels":
		if typed_letter not in ["a", "e", "i", "o", "u"]:
			base += 1
			$"../Panels/Timer_bar/Base_Rotate".agitate()
			if typed_letter.to_lower() == " ": #When word finished
				mult += 1
				$"../Panels/Timer_bar/Mult_Rotate".agitate()
			check_upgrades("on_type")
		else:
			trigger_agitation = true
	
	elif boss_effect.id == "less_time":
		max_timer_value = int(Sentences.correct_sentence.length() * 14)
		$"../Panels/Timer_bar".max_value = max_timer_value
		trigger_agitation = true
	
	elif boss_effect.id == "double_story":
		Sentences.correct_sentence += "; " + Sentences.create_sentence(is_upgrade_present("ignore_mistakes"))
		Sentences.correct_sentence = Sentences.correct_sentence.left(-1)
		trigger_agitation = true
	
	elif boss_effect.id == "no_mult_space":
		base += 1
		$"../Panels/Timer_bar/Base_Rotate".agitate()
		check_upgrades("on_type")
		if typed_letter == " ":
			trigger_agitation = true
	
	
	if trigger_agitation:
		$Gameplay/Boss_Effect_Rotate.agitate()


func check_boss_debuff(time):
	if boss_effect.trigger_time == time:
		return true
	return false

func set_SentenceShow_text(text):
	var to_fill
	if is_upgrade_present("ignore_mistakes"):
		to_fill = text.replacen(" ", "_") + "!"
	else:
		to_fill = text + "!"
	$Gameplay/SentenceShow.text = to_fill 

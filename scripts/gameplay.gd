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
var typed_already
var used_predictive = false
var base : int
var mult : int
var total_score = 0
var sentences_used = 0
var percentage_of_time = 0
var double_speed_amount = 0
var latest_letter = ""
var reroll_amount
var total_rerolls


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_gameplay_holder_new_round()


func timer_increment() -> void:
	time_passed += 1
	$"../Panels/Timer_bar".value = time_passed
	percentage_of_time = 1.25 - snapped((float(time_passed) / max_timer_value), 0.01)
	$"../Panels/Timer_bar/Timer_Rotate/Timer_Percentage".text = str(percentage_of_time)
	if time_passed >= max_timer_value:
		timer_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer_active :
		timer_increment()
	if timer_active and double_speed_amount > 0:
		double_speed_amount -= 1
		timer_increment()


func _on_sentence_take_text_changed(new_text: String) -> void:
	typed_already = new_text
	if !timer_active:
		timer_active = true
		$Rotate_Discard/Discard_Button.hide()
	var next_letter = sentence_left[0].to_lower()
	latest_letter = new_text[-1].to_lower()
	if latest_letter == next_letter:
		sentence_left = sentence_left.substr(1,-1)
		
		base += 1
		$"../Panels/Timer_bar/Base_Rotate".agitate()
		
		if latest_letter.to_lower() == " ": #When word finished
			mult += 1
			$"../Panels/Timer_bar/Mult_Rotate".agitate()
		
		check_upgrades("on_type")
		
		$"../Panels/Timer_bar/Base_Rotate/Base_Text".text = str(base)
		$"../Panels/Timer_bar/Mult_Rotate/Mult_Text".text = str(mult)
		
		typed_already = Sentences.correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/SentenceShow.text = ("[color=%s]" % palette.completed_text) + typed_already + ("[/color][color=%s]" % palette.other_text) + sentence_left + "!" 
		$Gameplay/TypingProgress.value += 1
	else: #Mistake has been made
		mistakes_made += 1
		double_speed_amount += 60
		check_upgrades("mistake_made")
		$Gameplay.agitate()
	if sentence_left.is_empty(): #Sentence has been typed correctly
		sentence_finished()


func update_stats():
	$"../Panels/Timer_bar/Hands_Rotate".agitate()
	$"../Panels/Timer_bar/Hands_Rotate/Hands_Counter".text = str(sentences_used) + " / " + str(PlayerStats.sentences_allowed)
	$"../Panels/Timer_bar/Total_Score_Rotate/Total_Score".text = str(total_score)
	$"../Panels/Timer_bar/Coins_Rotate/Coins_Counter".text = "£" + str(PlayerStats.coins)


func sentence_finished() -> void:
	sentences_used += 1
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
	update_stats()
	print(PlayerStats.target_this_round)
	if total_score >= PlayerStats.target_this_round:
		round_finished()
	elif sentences_used >= PlayerStats.sentences_allowed:
		$Gameplay/SentenceShow.text = "Game over \nPlease restart the game"
	else:
		$Rotate_Discard/Discard_Button.hide()
		$Rotate_Discard/Next_Button.show()


func sentence_start():
	discard_sentence()
	time_passed = 0
	$"../Panels/Timer_bar".value = time_passed
	$Gameplay/TypingProgress.value = 0
	base = 0
	mult = 0
	$"../Panels/Timer_bar/Base_Rotate/Base_Text".text = str(base)
	$"../Panels/Timer_bar/Mult_Rotate/Mult_Text".text = str(mult)
	$Rotate_Discard/Next_Button.hide()
	$Rotate_Discard/Discard_Button.hide()
	if reroll_amount > 0:
		$Rotate_Discard/Discard_Button.show()
	mistakes_made = 0
	sentences_used = 0
	is_first_letter = true
	update_stats()
	check_upgrades("sentence_start")


func round_finished() -> void:
	PlayerStats.completed_rounds += 1
	give_rewards()
	check_upgrades("end")
	$Gameplay/TypingProgress.hide()
	$ShopButton.show()


func give_rewards() -> void:
	var coins_increase = ((4 - sentences_used) * 2)
	if coins_increase < 1:
		coins_increase = 1
		multiple_coin = "Coin"
	else:
		multiple_coin = "Coins"
	PlayerStats.coins += coins_increase
	update_stats()


func _on_shop_button_pressed() -> void:
	$"..".initiate_shop()


func make_stylebox(color: Color, corner_radius: int = 6) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.corner_radius_top_left = corner_radius
	sb.corner_radius_top_right = corner_radius
	sb.corner_radius_bottom_left = corner_radius
	sb.corner_radius_bottom_right = corner_radius
	return sb


func apply_styling() -> void:
	palette = PlayerStats.palettes.pick_random()
	$"../Background".color = palette.background
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = Color(palette.completed_text)
	$Gameplay/TypingProgress.add_theme_stylebox_override("fill", bar_fill)
	$ShopButton.add_theme_stylebox_override("normal", make_stylebox(palette.shop_colour_normal))
	$ShopButton.add_theme_stylebox_override("hover", make_stylebox(palette.shop_colour_hover))
	$ShopButton.add_theme_stylebox_override("pressed", make_stylebox(palette.shop_colour_pressed))
	$ShopButton.add_theme_color_override("font_color", palette.shop_font)
	$ShopButton.add_theme_color_override("font_hover_color", palette.shop_font)
	$ShopButton.add_theme_color_override("font_pressed_color", palette.shop_font)


func _on_discard_button_pressed() -> void:
	if reroll_amount > 0:
		reroll_amount -= 1
		$Rotate_Discard/Discard_Button.text = "Reroll (" + str(reroll_amount) + "/" + str(total_rerolls) + ")"
		if reroll_amount <= 0:
			$Rotate_Discard/Discard_Button.hide()
		$Rotate_Discard.agitate()
		$Gameplay.agitate()
		discard_sentence()


func discard_sentence() -> void:
	Sentences.correct_sentence = Sentences.create_sentence()
	sentence_left = Sentences.correct_sentence
	$Gameplay/TypingProgress.max_value = Sentences.correct_sentence.length()
	$Gameplay/SentenceShow.text = ("[color=%s]" % palette.other_text) + Sentences.correct_sentence + "!"
	max_timer_value = int(Sentences.correct_sentence.length() * 23 * PlayerStats.round_time_mult)
	$"../Panels/Timer_bar".max_value = max_timer_value
	$Gameplay.rotation_degrees = randi_range(-25, 25)


func get_word_start_index(text: String, char_index: int) -> int:
	# Find the last space before char_index
	var last_space: int = -1
	for i in range(char_index):
		if text[i] == ' ':
			last_space = i
	return last_space + 1


func tab_autofill() -> void:
	if PlayerStats.amount_tab_fill > 0 and !used_predictive:
		used_predictive = true
		PlayerStats.amount_tab_fill -= 1
		var index_currently_typed = typed_already.length() - 1
		var index_of_word = get_word_start_index(Sentences.correct_sentence, index_currently_typed)
		var length_of_containing_word = 0
		var index_helper = index_of_word
		while Sentences.correct_sentence[index_helper] != " " and index_helper != (Sentences.correct_sentence.length()-1):
			index_helper += 1
			length_of_containing_word += 1
		sentence_left = sentence_left.substr((length_of_containing_word - (index_currently_typed - index_of_word)),-1)
		typed_already = Sentences.correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/TypingProgress.value += (length_of_containing_word - (index_currently_typed - index_of_word))
		$Gameplay/SentenceShow.text = ("[color=%s]" % palette.completed_text) + typed_already + ("[/color][color=%s]" % palette.other_text) + sentence_left + "!" 
		if sentence_left.is_empty():
			sentence_finished()


func _on_next_button_pressed() -> void:
	sentence_start()


func _on_gameplay_holder_new_round() -> void:
	total_score = 0
	apply_styling()
	$ShopButton.hide()
	update_stats()
	$"../Panels/Timer_bar/RequiredScoreRead".text = str(PlayerStats.target_this_round)
	reroll_amount = 1
	check_upgrades("round_start")
	total_rerolls = reroll_amount
	$Rotate_Discard/Discard_Button.text = "Reroll (" + str(reroll_amount) + "/" + str(total_rerolls) + ")"
	sentence_start()


func upgrade_apply(upgrade):
	if upgrade.id == "a_upgrade":
		if latest_letter.to_lower() == "a":
			mult += 2
			base += 2
			$"../Panels/Timer_bar/Mult_Rotate".agitate()
			return true
	elif upgrade.id == "flat_coin_increase":
		PlayerStats.coins += 2
		return true
	elif upgrade.id == "double_letters_bypass":
		if sentence_left == "": #prevents overstepping index
			pass
		elif latest_letter == sentence_left[0].to_lower(): #if current letter is also next letter
			mult += 2
			sentence_left = sentence_left.substr(1,-1)
			$Gameplay/TypingProgress.value += 1
			check_upgrades("on_type", upgrade.id)
			return true
	elif upgrade.id == "s_upgrade":
		if latest_letter.to_lower() == "s":
			mult = snapped((mult  * 1.25), 1)
			print("snapped to " + str(mult))
			return true
	elif upgrade.id == "mistake_penalty":
		double_speed_amount *= 0.75
		return true
	elif upgrade.id == "round_time_increase":
		$Gameplay/TypingProgress.max_value = snapped((Sentences.correct_sentence.length() * 1.25), 1)
		return true
	elif upgrade.id == "reroll_sentence":
		reroll_amount += 2
		return true
	else:
		return false


func check_upgrades(time, bypass = null):
	var active_upgrades = $"../Panels/Upgrades_Panel".active_upgrades
	for i in range(active_upgrades.size()):
		var upgrade = active_upgrades[i]
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

extends Node

var time_symbol = "⏱"

func mult_text(pretext):
	return "[color=#ea362d]" + pretext + " WC[/color]"
func base_text(pretext):
	return "[color=#318ace]" + pretext + " LC[/color]"
func timer_text(conttext):
	return "[color=#cd00e8]" + conttext + "[/color]"
func coin_text(conttext):
	return "[color=#f0c45b]" + conttext + "[/color]"
func hand_text(conttext):
	return "[color=#ac77ff]" + conttext + "[/color]"

var upgrades = [
	{
		"pretty_text": "Ghost Writer",
		"explanation": "Types second double letter & %s" % [mult_text("+6")],
		"id": "double_letters_bypass",
		"price": 4,
		"trigger_time": "on_type",
		"weight": 13
	},
	{
		"pretty_text": "Higher Wages",
		"explanation": "%s at end of round" % [coin_text("+£2")],
		"id": "flat_coin_increase",
		"price": 3,
		"trigger_time": "reward",
		"weight": 19
	},
	{
		"pretty_text": "Longer Deadlines",
		"explanation": "%s max" % [timer_text("+1/4 " + time_symbol)],
		"id": "round_time_increase",
		"price": 4,
		"trigger_time": "sentence_start",
		"weight": 13
	},
	{
		"pretty_text": "Autocorrect",
		"explanation": "%s mistake penalty" % [timer_text("-1/4 " + time_symbol)],
		"id": "mistake_penalty",
		"price": 6,
		"trigger_time": "mistake_made",
		"weight": 13
	},
	{
		"pretty_text": "Editor's Note",
		"explanation": "+2 discards every round",
		"id": "reroll_sentence",
		"price": 2,
		"trigger_time": "round_start",
		"weight": 19
	},
	{
		"pretty_text": "Predictive Text",
		"explanation": "Press Tab to automatically fill in the current word once per round",
		"id": "tab_to_fill",
		"price": 6,
		"trigger_time": "round_start",
		"weight": 8
	},
	{
		"pretty_text": "Ace Writer",
		"explanation": "Every typed \"A\" gives %s and %s" % [mult_text("+2"), base_text("+2")],
		"id": "a_upgrade",
		"price": 5,
		"trigger_time": "on_type",
		"weight": 13
	},
	{
		"pretty_text": "Sublime Text",
		"explanation": "Every typed \"S\" gives %s" % [mult_text("x1.5")],
		"id": "s_upgrade",
		"price": 6,
		"trigger_time": "on_type",
		"weight": 8
	},
	{
		"pretty_text": "Zippy Keys",
		"explanation": "every typed \"Z\" gives %s" % [mult_text("x2")],
		"id": "z_upgrade",
		"price": 4,
		"trigger_time": "on_type",
		"weight": 13
	},
	{
		"pretty_text": "Trusted Tabloid",
		"explanation": "%s every sentence" % [mult_text("+4")],
		"id": "flat_mult",
		"price": 4,
		"trigger_time": "sentence_end",
		"weight": 19
	},
	{
		"pretty_text": "Upgrade Stencil",
		"explanation": "%s for every empty upgrade slot (this included)" % [mult_text("x1.5")],
		"id": "empty_slot",
		"price": 6,
		"trigger_time": "sentence_end",
		"weight": 4
	},
	{
		"pretty_text": "Blueprint",
		"explanation": "Copy the ability of the upgrade above this one",
		"id": "copy_above",
		"price": 10,
		"trigger_time": "changes",
		"weight": 4
	},
	{
		"pretty_text": "Brainstorm",
		"explanation": "Copy the ability of the lowest upgrade",
		"id": "copy_bottom",
		"price": 10,
		"trigger_time": "changes",
		"weight": 4
	},
	{
		"pretty_text": "Surplus Items",
		"explanation": "+1 upgrade available in shop \n[cannot be copied]",
		"id": "shop_surplus",
		"price": 6,
		"trigger_time": "shop",
		"weight": 13
	},
	{
		"pretty_text": "Valued Customer",
		"explanation": "Rerolls start at %s" %[coin_text("£0")],
		"id": "low_reroll",
		"price": 5,
		"trigger_time": "shop",
		"weight": 13
	},
	{
		"pretty_text": "Mistake Fanatic",
		"explanation": "Typed mistakes still advance the sentence, but are not counted as typed",
		"id": "ignore_mistakes",
		"price": 5,
		"trigger_time": "mistake_made",
		"weight": 8
	},
	{
		"pretty_text": "Even Steven",
		"explanation": "Every typed \"e\" gives %s" % [base_text("+10")],
		"id": "e_upgrade",
		"price": 6,
		"trigger_time": "on_type",
		"weight": 8
	},
	{
		"pretty_text": "Abstract Artpiece",
		"explanation": "%s for every upgrade" % [mult_text("+3")],
		"id": "count_upgrade",
		"price": 6,
		"trigger_time": "sentence_end",
		"weight": 8
	},
	{
		"pretty_text": "Eye of Sauron",
		"explanation": "Every typed \"i\" %s per round" % [mult_text("accumulates +1")],
		"id": "i_upgrade",
		"price": 7,
		"trigger_time": "on_type",
		"weight": 8
	},
	{
		"pretty_text": "False Vowel",
		"explanation": "Every typed \"Y\" triggers vowel upgrades",
		"id": "y_upgrade",
		"price": 13,
		"trigger_time": "on_type",
		"weight": 4
	},
	{
		"pretty_text": "Business Insider",
		"explanation": "Interest max increases by %s " % [coin_text("£2")],
		"id": "up_interest",
		"price": 8,
		"trigger_time": "round_end",
		"weight": 13
	},
	{
		"pretty_text": "Ruler's Mania",
		"explanation": hand_text("+1 Story"),
		"id": "hand_increase",
		"price": 10,
		"trigger_time": "round_start",
		"weight": 4
	},
	{
		"pretty_text": "Loyalty Card",
		"explanation": "%s for every letter in the word \"coffee\" or \"tea\"" % [base_text("+5")],
		"id": "drink_card",
		"price": 7,
		"trigger_time": "on_type",
		"weight": 13
	},
	{
		"pretty_text": "Scoop of the Year",
		"explanation": "%s for typed letters with dips" % [coin_text("+£1")],
		"id": "dip_letter",
		"price": 8,
		"trigger_time": "on_type",
		"weight": 8
	},
	{
		"pretty_text": "Coupon Code",
		"explanation": "upgrades can appear multiple times in the shop",
		"id": "multi_show",
		"price": 6,
		"trigger_time": "shop",
		"weight": 8
	},
	{
		"pretty_text": "Flow State",
		"explanation": "Every 20 correct letters in a row gives %s" % [mult_text("+5")],
		"id": "consecutive_typing",
		"price": 8,
		"trigger_time": "on_type",
		"weight": 8
	},
]


#common: 19
#uncommon: 13
#rare: 8
#tricky: 4

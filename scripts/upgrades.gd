extends Node


var upgrades = [
	{
		"pretty_text": "Ghost Writer",
		"explanation": "Automatically types the next letter in a double-letter group and +3 mult when it does",
		"id": "double_letters_bypass",
		"price": 5,
		"trigger_time": "on_type",
		"weight": 10
	},
	{
		"pretty_text": "Higher Wages",
		"explanation": "+2 coins at end of round",
		"id": "flat_coin_increase",
		"price": 4,
		"trigger_time": "reward",
		"weight": 20
	},
	{
		"pretty_text": "Longer Deadlines",
		"explanation": "Increase timer max by 1/4",
		"id": "round_time_increase",
		"price": 5,
		"trigger_time": "sentence_start",
		"weight": 20
	},
	{
		"pretty_text": "Autocorrect",
		"explanation": "decrease the time that the timer is sped up by after a mistake by 1/4",
		"id": "mistake_penalty",
		"price": 8,
		"trigger_time": "mistake_made",
		"weight": 15
	},
	{
		"pretty_text": "Editor's Note",
		"explanation": "+2 discards every round",
		"id": "reroll_sentence",
		"price": 3,
		"trigger_time": "round_start",
		"weight": 20
	},
	{
		"pretty_text": "Predictive Text",
		"explanation": "Press Tab to automatically fill in the current word once per round",
		"id": "tab_to_fill",
		"price": 11,
		"trigger_time": "round_start",
		"weight": 10
	},
	{
		"pretty_text": "Ace Writer",
		"explanation": "Every typed \"A\" gives +2 mult and +2 base",
		"id": "a_upgrade",
		"price": 6,
		"trigger_time": "on_type",
		"weight": 5
	},
	{
		"pretty_text": "Sublime Text",
		"explanation": "Every typed \"S\" gives x1.25 mult",
		"id": "s_upgrade",
		"price": 7,
		"trigger_time": "on_type",
		"weight": 5
	},
	{
		"pretty_text": "Zippy Keys",
		"explanation": "every typed \"Z\" gives x2 mult ",
		"id": "z_upgrade",
		"price": 10,
		"trigger_time": "on_type",
		"weight": 10
	},
	{
		"pretty_text": "Trusted Tabloid",
		"explanation": "+4 mult every sentence",
		"id": "flat_mult",
		"price": 4,
		"trigger_time": "sentence_end",
		"weight": 20
	},
	{
		"pretty_text": "Upgrade Stencil",
		"explanation": "x1.5 mult for every empty upgrade slot (this included)",
		"id": "empty_slot",
		"price": 7,
		"trigger_time": "sentence_end",
		"weight": 8
	},
	{
		"pretty_text": "Blueprint",
		"explanation": "Copy the ability of the upgrade above this one",
		"id": "copy_above",
		"price": 10,
		"trigger_time": "changes",
		"weight": 5
	},
	{
		"pretty_text": "Brainstorm",
		"explanation": "Copy the ability of the lowest upgrade",
		"id": "copy_bottom",
		"price": 10,
		"trigger_time": "changes",
		"weight": 5
	},
	{
		"pretty_text": "Surplus Items",
		"explanation": "+1 upgrade available in shop \n[cannot be copied]",
		"id": "shop_surplus",
		"price": 10,
		"trigger_time": "shop",
		"weight": 15
	},
	{
		"pretty_text": "Valued Customer",
		"explanation": "Rerolls start at 0",
		"id": "low_reroll",
		"price": 6,
		"trigger_time": "shop",
		"weight": 14
	},
	{
		"pretty_text": "Mistake Fanatic",
		"explanation": "Mistakes are ignored",
		"id": "ignore_mistakes",
		"price": 9,
		"trigger_time": "mistake_made",
		"weight": 5
	},
]

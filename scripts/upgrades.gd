extends Node


var upgrades = [
	{
		"pretty_text": "Ghost writer",
		"explanation": "Automatically types the next letter in a double-letter group\nand gives +3 mult every time\n[can only be brought once]",
		"id": "double_letters_bypass",
		"price": 5,
		"trigger_time": "on_type"
	},
	{
		"pretty_text": "Higher wages",
		"explanation": "+2 coins at end of round",
		"id": "flat_coin_increase",
		"price": 4,
		"trigger_time": "end"
	},
	{
		"pretty_text": "Longer deadlines",
		"explanation": "Increase timer max by 1/4",
		"id": "round_time_increase",
		"price": 5,
		"trigger_time": "sentence_start"
	},
	{
		"pretty_text": "Autocorrect",
		"explanation": "decrease the time that the timer is sped up by after a mistake by 1/4",
		"id": "mistake_penalty",
		"price": 8,
		"trigger_time": "mistake_made"
	},
	{
		"pretty_text": "Editor's note",
		"explanation": "+2 discard every round",
		"id": "reroll_sentence",
		"price": 3,
		"trigger_time": "round_start"
	},
	{
		"pretty_text": "Predictive text",
		"explanation": "Press Tab to automatically fill in the current word once per round",
		"id": "tab_to_fill",
		"price": 11,
		"trigger_time": "round_start"
	},
	{
		"pretty_text": "Ace writer",
		"explanation": "Every typed \"A\" gives +2 mult and +2 base",
		"id": "a_upgrade",
		"price": 6,
		"trigger_time": "on_type"
	},
	{
		"pretty_text": "Sublime text",
		"explanation": "Every typed \"S\" gives x1.25 mult \n(not sponsored)",
		"id": "s_upgrade",
		"price": 7,
		"trigger_time": "on_type"
	},
]

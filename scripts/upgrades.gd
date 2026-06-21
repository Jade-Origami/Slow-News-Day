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
		"explanation": "Increase the amount of money given after round by 1",
		"id": "flat_coin_increase",
		"price": 4,
		"trigger_time": "end"
	},
	{
		"pretty_text": "Longer deadlines",
		"explanation": "Increase the amount of time allowed for a story to by completed by x1.25",
		"id": "round_time_increase",
		"price": 7,
		"trigger_time": "start"
	},
	{
		"pretty_text": "Autocorrect",
		"explanation": "3/4 the time that the timer is sped up when making a mistake",
		"id": "mistake_penalty",
		"price": 8,
		"trigger_time": "start"
	},
	{
		"pretty_text": "Editor's note",
		"explanation": "Tell your editor you want a different story!",
		"id": "reroll_sentence",
		"price": 3,
		"trigger_time": "start"
	},
	{
		"pretty_text": "Predictive text",
		"explanation": "Press Tab to automatically fill in the current word",
		"id": "tab_to_fill",
		"price": 15,
		"trigger_time": "during"
	},
	{
		"pretty_text": "Ace writer",
		"explanation": "Every typed \"A\" gives +2 mult and +2 base \n[can only be brought once]",
		"id": "a_upgrade",
		"price": 6,
		"trigger_time": "on_type"
	},
]

extends Node


var upgrades = [
	{
		"pretty_text": "Ghost writer",
		"explanation": "Automatically types the next letter in a double-letter group\nand gives +3 mult every time\n[can only be brought once]",
		"id": "double_letters_bypass",
		"mode": "set",
		"target": "double_bypass",
		"value": true,
		"price": 5,
		"rarity": "0.5", #common
		"trigger_time": "on_type"
	},
	{
		"pretty_text": "Higher wages",
		"explanation": "Increase the amount of money given after round by 1",
		"id": "flat_coin_increase",
		"mode": "add",
		"target": "flat_coin",
		"value": 1,
		"price": 4,
		"rarity": "0.2", #uncommon
		"trigger_time": "end"
	},
	{
		"pretty_text": "Longer deadlines",
		"explanation": "Increase the amount of time allowed for a story to by completed by x1.25",
		"id": "round_time_increase",
		"mode": "mult",
		"target": "round_time_mult",
		"value": 1.25,
		"price": 7,
		"rarity": "0.2", #uncommon
		"trigger_time": "start"
	},
	{
		"pretty_text": "Autocorrect",
		"explanation": "3/4 the time that the timer is sped up when making a mistake",
		"id": "mistake_penalty",
		"mode": "mult",
		"target": "mistake_mult_num",
		"value": 0.75,
		"price": 8,
		"rarity": "0.1", #rare
		"trigger_time": "start"
	},
	{
		"pretty_text": "Editor's note",
		"explanation": "Tell your editor you want a different story!",
		"id": "reroll_sentence",
		"mode": "add",
		"target": "reroll_sentence_amount",
		"value": 1,
		"price": 3,
		"rarity": "0.1", #rare
		"trigger_time": "start"
	},
	{
		"pretty_text": "Predictive text",
		"explanation": "Press Tab to automatically fill in the current word",
		"id": "tab_to_fill",
		"mode": "add",
		"target": "amount_tab_fill",
		"value": 1,
		"price": 15,
		"rarity": "0.2", #uncommon
		"trigger_time": "during"
	},
	{
		"pretty_text": "Ace writer",
		"explanation": "Every typed \"A\" gives +2 mult and +2 base \n[can only be brought once]",
		"id": "a_upgrade",
		"mode": "set",
		"target": "a_gives_mult",
		"value": true,
		"price": 6,
		"rarity": "0.2", #uncommon
		"trigger_time": "on_type"
	},
]


func apply_upgrade_by_id(id: String) -> void:
	for upgrade in upgrades:
		if upgrade["id"] == id:
			apply_upgrade(upgrade)
			break


func apply_upgrade(upgrade: Dictionary) -> void:
	var target = upgrade["target"]
	var mode = upgrade["mode"]
	var value = upgrade["value"]
	
	if upgrade["id"] == "double_letters_bypass":
		upgrades.erase(upgrade)
	if upgrade["id"] == "a_upgrade":
		upgrades.erase(upgrade)
	
	match mode:
		"set":
			PlayerStats.set(target, value)
		"add":
			PlayerStats.set(target, PlayerStats.get(target) + value)
		"mult":
			PlayerStats.set(target, PlayerStats.get(target) * value)

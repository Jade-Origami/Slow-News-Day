extends Panel

var round_reward
var hands_left
var pending_give_amount
var total_to_give

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_gameplay_holder_open_reward_screen(passed_round_reward, passed_hands_left) -> void:
	round_reward = passed_round_reward
	hands_left = passed_hands_left
	pending_give_amount = money_sources()
	$ShopButton.text = "Cash out: £" + str(pending_give_amount)


func _on_shop_button_pressed() -> void:
	$"..".add_money(pending_give_amount)
	$"..".initiate_shop()

func money_sources():
	#initialise
	$MoneySources.text = ""
	total_to_give = 0
	#set round reward (3, 4, ,5)
	$MoneySources.text += "Round Earnings: £" + str(round_reward)
	total_to_give += round_reward
	#£1 per hand left
	var hands_reward = hands_left * 1
	$MoneySources.text += "\n[font_size=40][color=#ac77ff][b]" + str(hands_left) + "[/b][/color][/font_size][valign y=-8.5]  Remaining Hands (£1 each) [/valign]"
	total_to_give += hands_reward
	#interest (£1 per £5 player currently has)
	@warning_ignore("integer_division")
	var interest_reward = floor(PlayerStats.coins / 5) * 1
	if interest_reward > 5:
		interest_reward = 5
	$MoneySources.text += "\n[font_size=40][color=#f0c45b][b]" + str(interest_reward) + "[/b][/color][/font_size][valign y=-8.5]  £1 interest per £5 held (max £5) [/valign]"
	total_to_give += interest_reward
	#check for upgrades that add on reward text
	$"../GameplayScreen".check_upgrades("reward")
	return total_to_give

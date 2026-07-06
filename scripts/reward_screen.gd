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
	$MoneySources.text = ""
	total_to_give = 0
	$MoneySources.text += "Round Earnings: £" + str(round_reward)
	total_to_give += round_reward
	var hands_reward = hands_left * 1
	$MoneySources.text += "\nHands Left (£1 per): £" + str(hands_left)
	total_to_give += hands_reward
	$"../GameplayScreen".check_upgrades("reward")
	return total_to_give

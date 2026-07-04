extends Panel

var money_from_round_to_give


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_gameplay_holder_open_reward_screen(money_from_round) -> void:
	money_from_round_to_give = money_from_round
	$ShopButton.text = "£" + str(money_from_round_to_give)


func _on_shop_button_pressed() -> void:
	$"..".add_money(money_from_round_to_give)
	$"..".initiate_shop()

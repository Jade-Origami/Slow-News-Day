extends Node2D
signal level_select
signal new_round (round_reward, boss_effect)
signal shop_start 
signal open_reward_screen (amount_from_round)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameplayScreen.hide()
	$ShopScene.hide()
	$Panels.show()
	$Level_Selector_Panel.show()


func initiate_round(round_reward, boss_effect):
	new_round.emit(round_reward, boss_effect)
	$GameplayScreen.show()
	$Level_Selector_Panel.hide()

func initiate_shop():
	shop_start.emit()
	$Reward_Panel.hide()
	$ShopScene.show()

func initiate_level_select():
	level_select.emit()
	$ShopScene.hide()
	$Level_Selector_Panel.show()

func initiate_reward_screen(amount, hands_left):
	open_reward_screen.emit(amount, hands_left)
	$GameplayScreen.hide()
	$Reward_Panel.show()

func add_money(amount):
	PlayerStats.coins += amount
	$Panels/Timer_bar/Coins_Rotate/Coins_Counter.text = "£" + str(PlayerStats.coins)
	$Panels/Timer_bar/Coins_Rotate.agitate()

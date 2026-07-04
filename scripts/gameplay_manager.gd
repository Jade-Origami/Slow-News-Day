extends Node2D
signal level_select
signal new_round (round_reward)
signal shop_start (amount_from_round)
signal open_reward_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameplayScreen.hide()
	$ShopScene.hide()
	$Panels.show()
	$Level_Selector_Panel.show()


func initiate_round(round_reward):
	new_round.emit(round_reward)
	$GameplayScreen.show()
	$Level_Selector_Panel.hide()

func initiate_shop():
	shop_start.emit()
	$GameplayScreen.hide()
	$ShopScene.show()

func initiate_level_select():
	level_select.emit()
	$ShopScene.hide()
	$Level_Selector_Panel.show()

func initiate_reward_screen():
	open_reward_screen.emit()
	$GameplayScreen.hide()
	$Reward_Panel.show()
	

func add_money(amount):
	PlayerStats.coins += amount
	$Panels/Timer_bar/Coins_Rotate/Coins_Counter.text = "£" + str(PlayerStats.coins)
	$Panels/Timer_bar/Coins_Rotate.agitate()

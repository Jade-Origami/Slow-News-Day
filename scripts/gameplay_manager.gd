extends Node2D
signal level_select
signal new_round (round_reward, boss_effect)
signal shop_start 
signal open_reward_screen (amount_from_round)
signal show_level_select
signal has_won
var level_select_shown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameplayScreen.hide()
	$ShopScene.hide()
	$Panels.show()
	initiate_level_select()


func initiate_round(round_reward, boss_effect):
	new_round.emit(round_reward, boss_effect)
	$GameplayScreen.show()
	$Level_Selector_Panel.hide()
	$View_Level.show()

func initiate_shop():
	shop_start.emit()
	$Reward_Panel.hide()
	$ShopScene.show()

func initiate_level_select():
	level_select.emit()
	$ShopScene.hide()
	$Level_Selector_Panel.show()
	$View_Level.hide()

func initiate_reward_screen(amount, hands_left):
	open_reward_screen.emit(amount, hands_left)
	$GameplayScreen.hide()
	$Reward_Panel.show()

func initiate_win_screen():
	has_won.emit()

func add_money(amount):
	PlayerStats.coins += amount
	$Panels/Timer_bar/Coins_Rotate/Coins_Counter.text = "£" + str(PlayerStats.coins)
	$Panels/Timer_bar/Coins_Rotate.agitate()


func _on_view_level_pressed() -> void:
	if level_select_shown:
		level_select_shown = false
		$Level_Selector_Panel.hide()
	else:
		level_select_shown = true
		show_level_select.emit()

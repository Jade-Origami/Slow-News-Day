extends Node2D

var item_1
var item_2
var item_3
var reroll_cost = 2

var rotate_reroll_button
var rotate_item_1
var rotate_item_2
var rotate_item_3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reroll()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if rotate_reroll_button:
		if PlayerStats.agitate_object($Rotate_Reroll):
			rotate_reroll_button = false
	if rotate_item_1:
		if PlayerStats.agitate_object($Rotate_1):
			rotate_item_1 = false
	if rotate_item_2:
		if PlayerStats.agitate_object($Rotate_2):
			rotate_item_2 = false
	if rotate_item_3:
		if PlayerStats.agitate_object($Rotate_3):
			rotate_item_3 = false


func _on_new_round_pressed() -> void:
	$"..".initiate_level_select()


func _on_item_1_pressed() -> void:
	reset_item_views()
	if $Rotate_1/Item_1/Buy_Button.visible:
		$Rotate_1/Item_1.text = item_1.pretty_text
	else:
		$Rotate_1/Item_1.text = item_1.explanation
	$Rotate_1/Item_1/Buy_Button.visible = !$Rotate_1/Item_1/Buy_Button.visible
	$Rotate_2/Item_2/Buy_Button.hide()
	$Rotate_3/Item_3/Buy_Button.hide()


func _item_1_bought() -> void:
	if (PlayerStats.coins >= item_1.price) and ($"../Panels/Upgrades_Panel".check_availability()):
		PlayerStats.coins -= item_1.price
		$"../Panels/Upgrades_Panel".item_added(item_1)
		print(str(item_1) + " has been brought")
		$Rotate_1/Item_1.hide()
		$Rotate_1/Item_1/Buy_Button.hide()
		update_stats_text()
	else:
		rotate_item_1 = true


func _on_item_2_pressed() -> void:
	reset_item_views()
	if $Rotate_2/Item_2/Buy_Button.visible:
		$Rotate_2/Item_2.text = item_2.pretty_text
	else:
		$Rotate_2/Item_2.text = item_2.explanation
	$Rotate_2/Item_2/Buy_Button.visible = !$Rotate_2/Item_2/Buy_Button.visible
	$Rotate_1/Item_1/Buy_Button.hide()
	$Rotate_3/Item_3/Buy_Button.hide()



func _item_2_bought() -> void:
	if (PlayerStats.coins >= item_2.price) and ($"../Panels/Upgrades_Panel".check_availability()):
		PlayerStats.coins -= item_2.price
		$"../Panels/Upgrades_Panel".item_added(item_2)
		print(str(item_2) + " has been brought")
		$Rotate_2/Item_2.hide()
		$Rotate_2/Item_2/Buy_Button.hide()
		update_stats_text()
	else:
		rotate_item_2 = true


func _on_item_3_pressed() -> void:
	reset_item_views()
	if $Rotate_3/Item_3/Buy_Button.visible:
		$Rotate_3/Item_3.text = item_3.pretty_text
	else:
		$Rotate_3/Item_3.text = item_3.explanation
	$Rotate_3/Item_3/Buy_Button.visible = !$Rotate_3/Item_3/Buy_Button.visible
	$Rotate_1/Item_1/Buy_Button.hide()
	$Rotate_2/Item_2/Buy_Button.hide()


func _item_3_bought() -> void:
	if (PlayerStats.coins >= item_3.price) and ($"../Panels/Upgrades_Panel".check_availability()):
		PlayerStats.coins -= item_3.price
		$"../Panels/Upgrades_Panel".item_added(item_3)
		print(str(item_3) + " has been brought")
		$Rotate_3/Item_3.hide()
		$Rotate_3/Item_3/Buy_Button.hide()
		update_stats_text()
	else:
		rotate_item_3 = true


func reroll() -> void:
	var shop_items = ["","",""]
	item_1 = Upgrades.upgrades.pick_random()
	$Rotate_1/Item_1.text = item_1.pretty_text
	$Rotate_1/Item_1/Buy_Button.text = str(item_1.price) + " Coins"
	shop_items[0] = item_1.id
	item_2 = Upgrades.upgrades.pick_random()
	while item_2.id in shop_items:
		item_2 = Upgrades.upgrades.pick_random()
	$Rotate_2/Item_2.text = item_2.pretty_text
	$Rotate_2/Item_2/Buy_Button.text = str(item_2.price) + " Coins"
	shop_items[1] = item_2.id
	item_3 = Upgrades.upgrades.pick_random()
	while item_3.id in shop_items:
		item_3 = Upgrades.upgrades.pick_random()
	$Rotate_3/Item_3.text = item_3.pretty_text
	$Rotate_3/Item_3/Buy_Button.text = str(item_3.price) + " Coins"
	shop_items[2] = item_3.id
	reroll_cost += 1
	$Rotate_Reroll/Reroll_button.text = "Reroll: " + str(reroll_cost) + " Coins"
	$Rotate_1/Item_1/Buy_Button.hide()
	$Rotate_2/Item_2/Buy_Button.hide()
	$Rotate_3/Item_3/Buy_Button.hide()
	$Rotate_1/Item_1.show()
	$Rotate_2/Item_2.show()
	$Rotate_3/Item_3.show()
	update_stats_text()


func _on_reroll_button_pressed() -> void:
	if PlayerStats.coins >= reroll_cost:
		PlayerStats.coins -= reroll_cost
		reroll()
		rotate_item_1 = true
		rotate_item_2 = true
		rotate_item_3 = true
	rotate_reroll_button = true


func update_stats_text() -> void:
	$"../Panels/Timer_bar/Coins_Rotate/Coins_Counter".text = "£" + str(PlayerStats.coins)


func reset_item_views():
	$Rotate_1/Item_1.text = item_1.pretty_text
	$Rotate_2/Item_2.text = item_2.pretty_text
	$Rotate_3/Item_3.text = item_3.pretty_text


func _on_gameplay_holder_shop_start() -> void:
	reroll()

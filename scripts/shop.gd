extends Node2D

var item_1
var item_2
var item_3
var reroll_cost = 2


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
		$"..".add_money(-item_1.price)
		$"../Panels/Upgrades_Panel".item_added(item_1)
		$Rotate_1/Item_1.hide()
		$Rotate_1/Item_1/Buy_Button.hide()
	else:
		$Rotate_1.agitate()


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
		$"..".add_money(-item_2.price)
		$"../Panels/Upgrades_Panel".item_added(item_2)
		$Rotate_2/Item_2.hide()
		$Rotate_2/Item_2/Buy_Button.hide()
	else:
		$Rotate_2.agitate()


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
		$"..".add_money(-item_3.price)
		$"../Panels/Upgrades_Panel".item_added(item_3)
		$Rotate_3/Item_3.hide()
		$Rotate_3/Item_3/Buy_Button.hide()
	else:
		$Rotate_3.agitate()


func reroll() -> void:
	var shop_items = ["","",""]
	item_1 = weighted_random(Upgrades.upgrades)
	while item_1 in $"../Panels/Upgrades_Panel".active_upgrades:
		item_1 = weighted_random(Upgrades.upgrades)
	$Rotate_1/Item_1.text = item_1.pretty_text
	$Rotate_1/Item_1/Buy_Button.text = str(item_1.price) + " Coins"
	shop_items[0] = item_1.id
	item_2 = weighted_random(Upgrades.upgrades)
	while item_2.id in shop_items or item_2 in $"../Panels/Upgrades_Panel".active_upgrades:
		item_2 = weighted_random(Upgrades.upgrades)
	$Rotate_2/Item_2.text = item_2.pretty_text
	$Rotate_2/Item_2/Buy_Button.text = str(item_2.price) + " Coins"
	shop_items[1] = item_2.id
	item_3 = weighted_random(Upgrades.upgrades)
	while item_3.id in shop_items or item_3 in $"../Panels/Upgrades_Panel".active_upgrades:
		item_3 = weighted_random(Upgrades.upgrades)
	$Rotate_3/Item_3.text = item_3.pretty_text
	$Rotate_3/Item_3/Buy_Button.text = str(item_3.price) + " Coins"
	shop_items[2] = item_3.id
	reroll_cost += 1
	$Rotate_Reroll/Reroll_button.text = "Reroll: " + str(reroll_cost) + " Coins"
	$Rotate_1/Item_1/Buy_Button.hide()
	$Rotate_2/Item_2/Buy_Button.hide()
	$Rotate_1/Item_1.show()
	$Rotate_2/Item_2.show()
	if $"../GameplayScreen".is_upgrade_present("shop_surplus"):
		$Rotate_3/Item_3.show()
	else:
		$Rotate_3/Item_3.hide()
	$Rotate_3/Item_3/Buy_Button.hide()


func _on_reroll_button_pressed() -> void:
	if PlayerStats.coins >= reroll_cost:
		$"..".add_money(-reroll_cost)
		reroll()
		$Rotate_1.agitate()
		$Rotate_2.agitate()
		$Rotate_3.agitate()
	$Rotate_Reroll.agitate()


func reset_item_views():
	$Rotate_1/Item_1.text = item_1.pretty_text
	$Rotate_2/Item_2.text = item_2.pretty_text
	$Rotate_3/Item_3.text = item_3.pretty_text


func _on_gameplay_holder_shop_start() -> void:
	if $"../GameplayScreen".is_upgrade_present("low_reroll"):
		reroll_cost = -1
	else:
		reroll_cost = 2
	reroll()


func weighted_random(list):
	var total_weight = 0
	for i in range(list.size()):
		total_weight += list[i].weight
	var random_weight = randi_range(1, total_weight)
	var accumulative_total = 0
	for i in range(list.size()):
		accumulative_total += list[i].weight
		if random_weight <= accumulative_total:
			return list[i]
	return 0

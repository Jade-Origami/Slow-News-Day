extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Rotate_Item_1/Item.hide()
	$Rotate_Item_2/Item.hide()
	$Rotate_Item_3/Item.hide()
	$Rotate_Item_4/Item.hide()


var active_upgrades = [null, null, null, null]


func hide_every_sell_button():
	$Rotate_Item_1/Item/Sell_Button.visible = false
	$Rotate_Item_2/Item/Sell_Button.visible = false
	$Rotate_Item_3/Item/Sell_Button.visible = false
	$Rotate_Item_4/Item/Sell_Button.visible = false

func _on_item_1_pressed() -> void:
	var before = $Rotate_Item_1/Item/Sell_Button.visible
	hide_every_sell_button()
	$Rotate_Item_1/Item/Sell_Button.visible = !before
	$Rotate_Item_1/Item/Sell_Button.text = "£" + str(snapped(active_upgrades[0].price/2, 1))

func _on_item_2_pressed() -> void:
	var before = $Rotate_Item_2/Item/Sell_Button.visible
	hide_every_sell_button()
	$Rotate_Item_2/Item/Sell_Button.visible = !before
	$Rotate_Item_2/Item/Sell_Button.text = "£" + str(snapped(active_upgrades[1].price/2, 1))

func _on_item_3_pressed() -> void:
	var before = $Rotate_Item_3/Item/Sell_Button.visible
	hide_every_sell_button()
	$Rotate_Item_3/Item/Sell_Button.visible = !before
	$Rotate_Item_3/Item/Sell_Button.text = "£" + str(snapped(active_upgrades[2].price/2, 1))

func _on_item_4_pressed() -> void:
	var before = $Rotate_Item_4/Item/Sell_Button.visible
	hide_every_sell_button()
	$Rotate_Item_4/Item/Sell_Button.visible = !before
	$Rotate_Item_4/Item/Sell_Button.text = "£" + str(snapped(active_upgrades[3].price/2, 1))


func item_added(item):
	if active_upgrades[0] == null:
		set_item(item, 0)
		$Rotate_Item_1/Item.show()
	elif active_upgrades[1] == null:
		set_item(item, 1)
		$Rotate_Item_2/Item.show()
	elif active_upgrades[2] == null:
		set_item(item, 2)
		$Rotate_Item_3/Item.show()
	elif active_upgrades[3] == null:
		set_item(item, 3)
		$Rotate_Item_4/Item.show()


func check_availability():
	for i in range(active_upgrades.size()):
		if active_upgrades[i] == null:
			return true


func set_item(item, pos) -> void:
	active_upgrades[pos] = item
	print(active_upgrades)
	update_panel(item, pos)


func update_panel(item, pos):
	if pos == 0:
		$Rotate_Item_1/Item.text = item.pretty_text
	elif pos == 1:
		$Rotate_Item_2/Item.text = item.pretty_text
	elif pos == 2:
		$Rotate_Item_3/Item.text = item.pretty_text
	elif pos == 3:
		$Rotate_Item_4/Item.text = item.pretty_text
	var amount_upgrades = 0
	for i in range(active_upgrades.size()):
		if active_upgrades[i] != null:
			amount_upgrades += 1
	$Upgrade_Counter.text = str(amount_upgrades) + "/" +  str(active_upgrades.size())


func _on_sell_button_1_pressed() -> void:
	$Rotate_Item_1/Item.hide()
	$Rotate_Item_1/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[0].price/2, 1))
	active_upgrades[0] = null

func _on_sell_button_2_pressed() -> void:
	$Rotate_Item_2/Item.hide()
	$Rotate_Item_2/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[1].price/2, 1))
	active_upgrades[1] = null

func _on_sell_button_3_pressed() -> void:
	$Rotate_Item_3/Item.hide()
	$Rotate_Item_3/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[2].price/2, 1))
	active_upgrades[2] = null

func _on_sell_button_4_pressed() -> void:
	$Rotate_Item_4/Item.hide()
	$Rotate_Item_4/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[3].price/2, 1))
	active_upgrades[3] = null
	

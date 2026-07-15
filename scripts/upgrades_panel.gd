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

func hide_every_move_button():
	$Rotate_Item_1/Item/Down_Button.hide()
	$Rotate_Item_2/Item/Up_Button.hide()
	$Rotate_Item_2/Item/Down_Button.hide()
	$Rotate_Item_3/Item/Up_Button.hide()
	$Rotate_Item_3/Item/Down_Button.hide()
	$Rotate_Item_4/Item/Up_Button.hide()


func _on_item_1_pressed() -> void:
	$Rotate_Item_1/Item.show()
	var before = $Rotate_Item_1/Item/Sell_Button.visible
	hide_every_sell_button()
	hide_every_move_button()
	$Rotate_Item_1/Item/Sell_Button.visible = !before
	$Rotate_Item_1/Item/Down_Button.visible = !before

func _on_item_2_pressed() -> void:
	$Rotate_Item_2/Item.show()
	var before = $Rotate_Item_2/Item/Sell_Button.visible
	hide_every_sell_button()
	hide_every_move_button()
	$Rotate_Item_2/Item/Sell_Button.visible = !before
	$Rotate_Item_2/Item/Up_Button.visible = !before
	$Rotate_Item_2/Item/Down_Button.visible = !before

func _on_item_3_pressed() -> void:
	$Rotate_Item_3/Item.show()
	var before = $Rotate_Item_3/Item/Sell_Button.visible
	hide_every_sell_button()
	hide_every_move_button()
	$Rotate_Item_3/Item/Sell_Button.visible = !before
	$Rotate_Item_3/Item/Up_Button.visible = !before
	$Rotate_Item_3/Item/Down_Button.visible = !before

func _on_item_4_pressed() -> void:
	$Rotate_Item_4/Item.show()
	var before = $Rotate_Item_4/Item/Sell_Button.visible
	hide_every_sell_button()
	hide_every_move_button()
	$Rotate_Item_4/Item/Sell_Button.visible = !before
	$Rotate_Item_4/Item/Up_Button.visible = !before


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
	update_panel(item, pos)


func update_panel(item, pos):
	if active_upgrades[pos] == null:
		if pos == 0:
			$Rotate_Item_1/Item.hide()
		elif pos == 1:
			$Rotate_Item_2/Item.hide()
		elif pos == 2:
			$Rotate_Item_3/Item.hide()
		else:
			$Rotate_Item_4/Item.hide()
		return
	if pos == 0:
		$Rotate_Item_1/Item.text = item.pretty_text
		$Rotate_Item_1/Item/Sell_Button.text = "£" + str(snapped(item.price/2, 1))
	elif pos == 1:
		$Rotate_Item_2/Item.text = item.pretty_text
		$Rotate_Item_2/Item/Sell_Button.text = "£" + str(snapped(item.price/2, 1))
	elif pos == 2:
		$Rotate_Item_3/Item.text = item.pretty_text
		$Rotate_Item_3/Item/Sell_Button.text = "£" + str(snapped(item.price/2, 1))
	elif pos == 3:
		$Rotate_Item_4/Item.text = item.pretty_text
		$Rotate_Item_4/Item/Sell_Button.text = "£" + str(snapped(item.price/2, 1))
	var amount_upgrades = 0
	for i in range(active_upgrades.size()):
		if active_upgrades[i] != null:
			amount_upgrades += 1
	$Upgrade_Counter.text = str(amount_upgrades) + "/" +  str(active_upgrades.size())


func whole_panel_update():
	for i in range(active_upgrades.size()):
		update_panel(active_upgrades[i], i)


func _on_sell_button_1_pressed() -> void:
	hide_every_move_button()
	$Rotate_Item_1/Item.hide()
	$Rotate_Item_1/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[0].price/2, 1))
	active_upgrades[0] = null

func _on_sell_button_2_pressed() -> void:
	hide_every_move_button()
	$Rotate_Item_2/Item.hide()
	$Rotate_Item_2/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[1].price/2, 1))
	active_upgrades[1] = null

func _on_sell_button_3_pressed() -> void:
	hide_every_move_button()
	$Rotate_Item_3/Item.hide()
	$Rotate_Item_3/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[2].price/2, 1))
	active_upgrades[2] = null

func _on_sell_button_4_pressed() -> void:
	hide_every_move_button()
	$Rotate_Item_4/Item.hide()
	$Rotate_Item_4/Item/Sell_Button.hide()
	$"../..".add_money(snapped(active_upgrades[3].price/2, 1))
	active_upgrades[3] = null
	


func Item_1_Down() -> void:
	var temp = active_upgrades[0]
	active_upgrades[0] = active_upgrades[1]
	active_upgrades[1] = temp
	whole_panel_update()
	_on_item_2_pressed()
	


func Item_2_Up() -> void:
	var temp = active_upgrades[1]
	active_upgrades[1] = active_upgrades[0]
	active_upgrades[0] = temp
	whole_panel_update()
	_on_item_1_pressed()


func Item_2_Down() -> void:
	var temp = active_upgrades[1]
	active_upgrades[1] = active_upgrades[2]
	active_upgrades[2] = temp
	whole_panel_update()
	_on_item_3_pressed()


func Item_3_Up() -> void:
	var temp = active_upgrades[2]
	active_upgrades[2] = active_upgrades[1]
	active_upgrades[1] = temp
	whole_panel_update()
	_on_item_2_pressed()


func Item_3_Down() -> void:
	var temp = active_upgrades[2]
	active_upgrades[2] = active_upgrades[3]
	active_upgrades[3] = temp
	whole_panel_update()
	_on_item_4_pressed()


func Item_4_Up() -> void:
	var temp = active_upgrades[3]
	active_upgrades[3] = active_upgrades[2]
	active_upgrades[2] = temp
	whole_panel_update()
	_on_item_3_pressed()


func _on_item_1_mouse_entered() -> void:
	$Rotate_Item_1/Item.text = active_upgrades[0].explanation
func _on_item_1_mouse_exited() -> void:
	$Rotate_Item_1/Item.text = active_upgrades[0].pretty_text

func _on_item_2_mouse_entered() -> void:
	$Rotate_Item_2/Item.text = active_upgrades[1].explanation
func _on_item_2_mouse_exited() -> void:
	$Rotate_Item_2/Item.text = active_upgrades[1].pretty_text

func _on_item_3_mouse_entered() -> void:
	$Rotate_Item_3/Item.text = active_upgrades[2].explanation
func _on_item_3_mouse_exited() -> void:
	$Rotate_Item_3/Item.text = active_upgrades[2].pretty_text

func _on_item_4_mouse_entered() -> void:
	$Rotate_Item_4/Item.text = active_upgrades[3].explanation
func _on_item_4_mouse_exited() -> void:
	$Rotate_Item_4/Item.text = active_upgrades[3].pretty_text

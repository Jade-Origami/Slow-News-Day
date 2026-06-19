extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


var active_upgrades = [null, null, null, null]


func _on_item_1_pressed() -> void:
	$Rotate_Item_1/Item/Sell_Button.visible = !$Rotate_Item_1/Item/Sell_Button.visible
	$Rotate_Item_2/Item/Sell_Button.visible = false
	$Rotate_Item_3/Item/Sell_Button.visible = false
	$Rotate_Item_4/Item/Sell_button.visible = false

func _on_item_2_pressed() -> void:
	$Rotate_Item_2/Item/Sell_Button.visible = !$Rotate_Item_2/Item/Sell_Button.visible
	$Rotate_Item_1/Item/Sell_Button.visible = false
	$Rotate_Item_3/Item/Sell_Button.visible = false
	$Rotate_Item_4/Item/Sell_button.visible = false

func _on_item_3_pressed() -> void:
	$Rotate_Item_3/Item/Sell_Button.visible = !$Rotate_Item_3/Item/Sell_Button.visible
	$Rotate_Item_1/Item/Sell_Button.visible = false
	$Rotate_Item_2/Item/Sell_Button.visible = false
	$Rotate_Item_4/Item/Sell_button.visible = false

func _on_item_4_pressed() -> void:
	$Rotate_Item_4/Item/Sell_button.visible = !$Rotate_Item_4/Item/Sell_button.visible
	$Rotate_Item_1/Item/Sell_Button.visible = false
	$Rotate_Item_2/Item/Sell_Button.visible = false
	$Rotate_Item_3/Item/Sell_Button.visible = false


func item_added(item) -> void:
	if active_upgrades[0] == null:
		set_item(item, 0)
	elif active_upgrades[1] == null:
		set_item(item, 1)
	elif active_upgrades[2] == null:
		set_item(item, 2)
	elif active_upgrades[3] == null:
		set_item(item, 3)
	pass


func set_item(item, pos) -> void:
	active_upgrades[pos] = item
	print(active_upgrades)
	Upgrades.apply_upgrade_by_id(item.id)
	update_whole_panel()


func update_whole_panel():
	if $Rotate_Item_1/Item.text != null:
		$Rotate_Item_1/Item.text = active_upgrades[0].pretty_text
	if $Rotate_Item_2/Item.text != null:
		$Rotate_Item_2/Item.text = active_upgrades[1].pretty_text
	if $Rotate_Item_3/Item.text != null:
		$Rotate_Item_3/Item.text = active_upgrades[2].pretty_text
	if $Rotate_Item_4/Item.text != null:
		$Rotate_Item_4/Item.text = active_upgrades[3].pretty_text

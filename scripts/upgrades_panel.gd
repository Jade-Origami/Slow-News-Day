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


func set_item_1(item) -> void:
	active_upgrades[0] = item
	print(active_upgrades)
	whole_panel_update()

func whole_panel_update() -> void:
	$Rotate_Item_1/Item.text = active_upgrades[0].pretty_text

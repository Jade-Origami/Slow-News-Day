extends Node2D
signal level_select
signal new_round

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameplayScreen.hide()
	$ShopScene.hide()
	$Panels.show()
	$Level_selector.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func initiate_round():
	new_round.emit()
	$GameplayScreen.show()
	$Level_selector.hide()

func initiate_shop():
	$GameplayScreen.hide()
	$ShopScene.show()

func initiate_level_select():
	level_select.emit()
	$ShopScene.hide()
	$Level_selector.show()

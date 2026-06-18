extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameplayScreen.hide()
	$ShopScene.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func initiate_round():
	$GameplayScreen.show()
	$Level_selector.hide()

func initiate_shop():
	$GameplayScreen.hide()
	$ShopScene.show()

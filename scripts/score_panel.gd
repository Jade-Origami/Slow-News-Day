extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_stats(total_score, sentences_used):
	$Coins_Rotate/Coins_Counter.text = "£" + str(PlayerStats.coins)
	$Hands_Rotate/Hands_Counter.text = str(sentences_used) + " / " + str(PlayerStats.sentences_allowed)
	$Total_Score_Rotate/Total_Score.text = str(total_score)
	return true

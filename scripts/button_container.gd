extends Control

@onready var rich_text: RichTextLabel = $Text

var text: String:
	get:
		return rich_text.text
	set(value):
		#rich_text.bbcode_enabled = true
		$Text.text = value

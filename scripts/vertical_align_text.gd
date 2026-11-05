@tool
class_name RichTextVAlign
extends RichTextEffect

# Defines the BBCode tag name: [valign]
var bbcode = "valign"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# Reads the 'y' argument from the BBCode tag and offsets the character
	# Note: Godot 2D coordinates go down, so positive y shifts text down, negative shifts up
	var y_offset = char_fx.env.get("y", 0.0)
	char_fx.offset.y = y_offset
	return true

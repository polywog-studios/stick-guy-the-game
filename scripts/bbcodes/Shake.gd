@tool
class_name ShakingBBCode extends RichTextEffect
 
# [shk][/shk]
var bbcode = "shk"

func _process_custom_fx(char_fx):
	char_fx.offset.x = randi_range(-1,1)
	char_fx.offset.y = randi_range(-1,1)

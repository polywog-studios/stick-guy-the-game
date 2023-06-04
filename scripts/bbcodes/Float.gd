@tool
class_name FloatingBBCode extends RichTextEffect
 
# [flt][/flt]
var bbcode = "flt"

func _process_custom_fx(char_fx):
	char_fx.offset.y = sin(char_fx.relative_index+char_fx.elapsed_time*2)*2

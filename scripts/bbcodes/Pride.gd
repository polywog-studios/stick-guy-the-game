@tool
class_name PrideBBCode extends RichTextEffect
 
# [pride flag=<flag>][/pride]
var bbcode = "pride"

func _process_custom_fx(char_fx):
	if char_fx.env.has('flag'):
		var colors = [Color.WHITE]
		match (char_fx.env.flag):
			'mlm':
				colors = [
					Color.AQUA,
					Color.AQUAMARINE,
					Color.WHITE, 
					Color.SLATE_BLUE,
					Color.DARK_SLATE_BLUE,
				]
			'lesbian':
				colors = [
					Color.ORANGE_RED,
					Color.SANDY_BROWN,
					Color.WHITE,
					Color.ORCHID,
					Color.DARK_MAGENTA,
				]
			'bi':
				colors = [
					Color.MEDIUM_VIOLET_RED,
					Color.MEDIUM_VIOLET_RED,
					Color.MEDIUM_PURPLE, 
					Color.MEDIUM_BLUE,
					Color.MEDIUM_BLUE,
				]
			'pan':
				colors = [
					Color.DEEP_PINK,
					Color.GOLD,
					Color.DEEP_SKY_BLUE
				]
			'trans':
				colors = [
					Color.DEEP_SKY_BLUE,
					Color.HOT_PINK,
					Color.WHITE, 
					Color.HOT_PINK,
				]
		char_fx.color = colors[(int((char_fx.relative_index+char_fx.elapsed_time*10)/2))%colors.size()]
		return true
	else:
		char_fx.color = Color.from_hsv(fmod(char_fx.elapsed_time+char_fx.relative_index/50.0, 1.0), 1, 1)
		return true

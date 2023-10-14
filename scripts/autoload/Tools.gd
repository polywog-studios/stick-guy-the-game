extends Node

const PLAYER_COLORS:Dictionary = {
	"red": Color('e64539'),
	"yellow": Color('f0b541'),
	"green": Color('63ab3f'),
	"blue": Color('4fa4b8')
}

const COLORS:Dictionary = {
	"red": Color('e64539'),
	"yellow": Color('f0b541'),
	"green": Color('63ab3f'),
	"blue": Color('4fa4b8'),
	
	"L_red": Color('ffc2a1'),
	"L_yellow": Color('ffee83'),
	"L_green": Color('c8d45d'),
	"L_blue": Color('92e8c0'),
	
	"D_red": Color('ad2f45'),
	"D_yellow": Color('cf752b'),
	"D_green": Color('3b7d4f'),
	"D_blue": Color('4c6885'),
	
	"L_white": Color('f5ffe8'),
	"white": Color('dfe0e8'),
	"D_white": Color('a3a7c2'),
	
	"black": Color('14182e'),
	"L_black": Color('2c354d')
}

var current_level:Node2D = load("res://scenes/game/levels/Level1.tscn").instantiate()

func _ready() -> void:
	RenderingServer.set_default_clear_color(COLORS.L_red)

func change_window_icon(texture:Texture2D) -> void:
	DisplayServer.set_icon(texture.get_image())

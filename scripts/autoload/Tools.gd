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
	"D_blue": Color('4c6885')
}

var current_level:Node2D = load("res://scenes/game/levels/Level1.tscn").instantiate()

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.WHITE)

func change_window_icon(texture:Texture2D) -> void:
	DisplayServer.set_icon(texture.get_image())

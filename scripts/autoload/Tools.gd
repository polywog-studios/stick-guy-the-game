extends Node

const PLAYER_COLORS:Dictionary = {
	"red": Color('e64539'),
	"yellow": Color('ffee83'),
	"green": Color('63ab3f'),
	"blue": Color('4fa4b8')
}

var current_level:Node2D = load("res://scenes/game/levels/Level1.tscn").instantiate()

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.WHITE)

func change_window_icon(texture:Texture2D) -> void:
	DisplayServer.set_icon(texture.get_image())

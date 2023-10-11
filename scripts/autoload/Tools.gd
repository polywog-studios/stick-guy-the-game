extends Node

const PLAYER_COLORS:Dictionary = {
	"red": Color.RED,
	"orange": Color.DARK_ORANGE,
	"lime": Color.LIME,
	"blue": Color.BLUE
}

var current_level:PackedScene = load("res://scenes/game/levels/Level1.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.WHITE)

func change_window_icon(texture:Texture2D) -> void:
	DisplayServer.set_icon(texture.get_image())

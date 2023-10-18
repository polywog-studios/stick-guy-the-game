class_name Gameplay extends Node2D

@onready var player:Player = $Players/Player
@onready var camera:Camera2D = $Camera2D
@onready var color_picker:HBoxContainer = $UILayer/ColorPicker

var cur_color:int = 0
var window_icons:Dictionary = {}

func _ready():
	camera.position = player.position
	if is_instance_valid(Tools.current_level):
		var cool = Tools.current_level.duplicate()
		cool.name = 'Level'
		add_child(cool)
		move_child(cool, 0)
	
	player.on_death.connect(reset_player)
	
	for color in Tools.PLAYER_COLORS.keys():
		var square:ColorPickerSquare = load("res://scenes/game/ColorPickerSquare.tscn").instantiate()
		square.selected = (color == player.color)
		square.modulate = Tools.PLAYER_COLORS[color]
		color_picker.add_child(square)
		window_icons[color] = load("res://assets/game_icons/%s.png" % color)
		
	reset_player()
	
func _process(delta:float):
	camera.position = player.position + Vector2(player.velocity.x / 2.0, -25.0)
	
	if Input.is_action_just_pressed("color_left"):
		cur_color = wrapi(cur_color - 1, 0, Tools.PLAYER_COLORS.keys().size())
		update_color_picker()

	if Input.is_action_just_pressed("color_right"):
		cur_color = wrapi(cur_color + 1, 0, Tools.PLAYER_COLORS.keys().size())
		update_color_picker()
		
	RenderingServer.set_default_clear_color(lerp(RenderingServer.get_default_clear_color(), Tools.COLORS['L_'+player.color], 5*delta))

func update_color_picker():
	for i in color_picker.get_child_count():
		player.set_collision_layer_value(i + 2, false)
		player.set_collision_mask_value(i + 2, false)
		var square:ColorPickerSquare = color_picker.get_child(i)
		square.selected = (cur_color == i)
	
	player.set_collision_layer_value(cur_color + 2, true)
	player.set_collision_mask_value(cur_color + 2, true)
	
	player.color = Tools.PLAYER_COLORS.keys()[cur_color]
	player.sprite.modulate = Tools.PLAYER_COLORS[player.color]
	
	player.nametag_arrow.modulate = Tools.COLORS['D_'+player.color]
	player.nametag.add_theme_color_override('font_color', Tools.COLORS['D_'+player.color])
	player.nametag.add_theme_color_override('font_outline_color', Tools.COLORS['L_'+player.color])
	
	Tools.change_window_icon(window_icons[player.color])

func reset_player():
	if is_instance_valid(Tools.current_level):
		player.position = Tools.current_level.get_node("SpawnPos").position

	cur_color = 0
	update_color_picker()
	
func _exit_tree():
	Tools.change_window_icon(load("res://assets/game_icons/generic.png"))

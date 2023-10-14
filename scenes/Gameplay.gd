class_name Gameplay extends Node2D

@onready var player:Player = $Players/Player
@onready var camera:Camera2D = $Camera2D
@onready var color_picker:HBoxContainer = $UILayer/ColorPicker

var cur_color:int = 0
var window_icons:Dictionary = {}

func _ready():
	camera.position = player.position
	if is_instance_valid(Tools.current_level):
		add_child(Tools.current_level)
		move_child(Tools.current_level, 0)
	
	player.on_death.connect(reset_player)
	
	for color in Tools.PLAYER_COLORS.keys():
		var square:ColorPickerSquare = load("res://scenes/game/ColorPickerSquare.tscn").instantiate()
		square.selected = (color == player.color)
		square.modulate = Tools.PLAYER_COLORS[color]
		color_picker.add_child(square)
		window_icons[color] = load("res://assets/game_icons/%s.png" % color)
		
	reset_player()
	
func _process(delta:float):
	camera.position = camera.position.lerp(player.position - Vector2(0.0, 50.0), delta * 5)
	
	if camera.position.x < 320.0: camera.position.x = 320.0
	if camera.position.y > 330.0: camera.position.y = 330.0
		
	if Input.is_action_just_pressed("color_left"):
		cur_color = wrapi(cur_color - 1, 0, Tools.PLAYER_COLORS.keys().size())
		update_color_picker()

	if Input.is_action_just_pressed("color_right"):
		cur_color = wrapi(cur_color + 1, 0, Tools.PLAYER_COLORS.keys().size())
		update_color_picker()

func update_color_picker():
	for i in color_picker.get_child_count():
		player.set_collision_layer_value(i + 1, false)
		player.set_collision_mask_value(i + 1, false)
		var square:ColorPickerSquare = color_picker.get_child(i)
		square.selected = (cur_color == i)
	
	player.set_collision_layer_value(cur_color + 1, true)
	player.set_collision_mask_value(cur_color + 1, true)
	
	player.color = Tools.PLAYER_COLORS.keys()[cur_color]
	player.sprite.modulate = Tools.PLAYER_COLORS[player.color]
	Tools.change_window_icon(window_icons[player.color])

func reset_player():
	if is_instance_valid(Tools.current_level):
		player.position = Tools.current_level.get_node("SpawnPos").position

	cur_color = 0
	update_color_picker()
	
func _exit_tree():
	Tools.change_window_icon(load("res://assets/game_icons/generic.png"))

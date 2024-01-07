class_name DevMenu extends Control

@export var current_screen:DevMenuScreen

func _ready():
	# each child is a menu
	for screen in get_children():
		screen.visible = (screen == current_screen)

func switch_screen(screen_name:String):
	current_screen.visible = false
	current_screen = get_node(NodePath(screen_name))
	current_screen.visible = true

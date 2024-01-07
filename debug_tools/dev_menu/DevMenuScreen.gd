class_name DevMenuScreen extends Control

@onready var dev_menu:DevMenu = $"../"

@export var current_selection:int = 0
@export var minimum_selection:int = 0
@export var maximum_selection:int = 0

func _ready():
	change_selection(0, true)

func change_selection(by:int = 0, force:bool = false):
	if by == 0 and not force: return
	current_selection = wrapi(current_selection + by, minimum_selection, maximum_selection)
	print("Selected Option: %s" % [current_selection])
	
# this is for you to implement yourself
func select_option():
	pass
	
func input_check():
	var axis:int = round(Input.get_axis("ui_up", "ui_down"))
	if axis != 0:
		change_selection(axis)
	
	if Input.is_action_just_pressed("ui_select"):
		select_option()

func _input(event:InputEvent):
	if dev_menu.current_screen != self:
		return
	
	if event is InputEventKey:
		event = event as InputEventKey # have to cast otherwise code completion won't work
		if not event.pressed:
			return
		
		input_check()

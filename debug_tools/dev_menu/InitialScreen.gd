extends DevMenuScreen

@onready var options:VBoxContainer = $Options

func _ready():
	maximum_selection = options.get_child_count()
	super()

func change_selection(by:int = 0, force:bool = false):
	super(by, force) # i love not having to worry about using super in godot unlike in hxcpp where i shit myself in 17.42 directions
	
	# thank you godot for adding typed shit in for loops ❤️❤️❤️
	for i in options.get_child_count():
		var option:Label = options.get_child(i) as Label # casting for code completion
		option.modulate = Tools.color_from_bool(current_selection == i)
		
		if current_selection == i:
			option.text = "< %s >" % [option.name]
		else:
			option.text = option.name
			
func select_option():
	match options.get_child(current_selection).name:
		&"Gameplay":
			print("Loading into Gameplay [LV1]...")
			get_tree().change_scene_to_file("res://scenes/Gameplay.tscn")
		
		&"Main Menu":
			print("Loading into Main Menu...")
			get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		
		&"Settings":
			print("Showing settings screen...")
			dev_menu.switch_screen("SettingsScreen")
		
		&"Exit":
			print("Quitting game...")
			get_tree().quit()

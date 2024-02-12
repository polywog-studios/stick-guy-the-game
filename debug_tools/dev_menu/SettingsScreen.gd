extends DevMenuScreen

@onready var settings_list:VBoxContainer = $SettingsList

func _ready():
	maximum_selection = settings_list.get_child_count()
	super()
	
func input_check():
	var axis:int = floor(Input.get_axis("ui_up", "ui_down"))
	if axis != 0:
		change_selection(axis)
	
	if Input.is_action_just_pressed("ui_cancel"):
		dev_menu.switch_screen("InitialScreen")
	
	if settings_list.get_child(current_selection) is DevBooleanSetting and Input.is_action_just_pressed("ui_select"):
		(settings_list.get_child(current_selection) as DevBooleanSetting).toggle()
		change_selection(0, true)
		
	var int_axis:int = int(signf(Input.get_axis("ui_left", "ui_right")))
	if settings_list.get_child(current_selection) is DevIntegerSetting and int_axis != 0:
		(settings_list.get_child(current_selection) as DevIntegerSetting).change(int_axis)
		change_selection(0, true)
		
	if settings_list.get_child(current_selection) is DevFloatSetting and int_axis != 0:
		(settings_list.get_child(current_selection) as DevFloatSetting).change(int_axis)
		change_selection(0, true)

func change_selection(by:int = 0, force:bool = false):
	super(by, force) # i love not having to worry about using super in godot unlike in hxcpp where i shit myself in 17.42 directions
	
	# thank you godot for adding typed shit in for loops ❤️❤️❤️
	for i in settings_list.get_child_count():
		var setting:DevSetting = settings_list.get_child(i) as DevSetting # casting for code completion
		setting.modulate = Tools.color_from_bool(current_selection == i)
		
		if current_selection == i:
			setting.text = "> %s %s" % [setting.name, setting.data_to_string()]
		else:
			setting.text = "%s %s" % [setting.name, setting.data_to_string()]

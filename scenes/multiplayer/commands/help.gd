extends BaseCommand

func _init():
	description = "Displays a list of every command available with their descriptions."
	
func _ready():
	var help_shit:String = ""
	var folder:String = "res://scenes/multiplayer/commands"
	var dir := DirAccess.open(folder)
	
	var darnell_wet_fart = dir.get_files()
	for item in darnell_wet_fart:
		var og_item:String = item
		
		# replace .remap shit because it appears specifically
		# in export builds
		var cmd_path:String = folder+"/"+og_item.replace(".remap", "")
		
		var command_data = Node.new()
		command_data.set_script(load(cmd_path))
		item = "/"+item.replace(".gd", "").replace(".remap", "")
		help_shit += item +" - "+ command_data.description + ("\n" if og_item != darnell_wet_fart[darnell_wet_fart.size()-1] else "")
		
	game._submit_raw_local_message(help_shit, ":3")

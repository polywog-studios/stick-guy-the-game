extends BaseCommand

func _ready():
	var help_shit:String = ""
	var folder:String = "res://scenes/multiplayer/commands"
	var dir := DirAccess.open(folder)
	
	var darnell_wet_fart = dir.get_files()
	for item in darnell_wet_fart:
		var og_item:String = item
		if not ".tscn" in item:
			continue
		
		# replace .remap shit because it appears specifically
		# in export builds
		var scene_path:String = folder+"/"+og_item.replace(".remap", "")
		var scene_data:BaseCommand = load(scene_path).instantiate()
		item = "/"+item.replace(".tscn", "").replace(".remap", "")
		help_shit += item +" - "+ scene_data.description + ("\n" if og_item != darnell_wet_fart[darnell_wet_fart.size()-1] else "")
		
	game._submit_raw_local_message(help_shit, ":3")

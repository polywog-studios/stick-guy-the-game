extends BaseCommand

func _ready():
	match parameters[0]:
		'help':
			run_help()
		'none':
			game.rpc('remove_player_tag', peer_id, 'hat')
		_:
			game.rpc('add_player_tag', peer_id, 'hat', parameters[0])

func run_help():
	var help_shit:String = "--== Hats you can switch to (do /hat HAT_NAME) ==--\n"
	var folder:String = "res://images/hats"
	var dir := DirAccess.open(folder)
	
	var darnell_wet_fart = dir.get_files()
	for item in darnell_wet_fart:
		var og_item:String = item
		if not ".png" in item or not ".import" in item:
			continue
		
		for ext in PackedStringArray([".png", ".jpg", ".jpeg", ".bmp"]):
			item = item.replace(ext, "")
		
		# replace .import shit because it appears
		# in export builds
		item = item.replace(".import", "")
		help_shit += "/hat "+item + ("\n" if og_item != darnell_wet_fart[darnell_wet_fart.size()-1] else "")
		
	game._submit_raw_local_message(help_shit, ":3")

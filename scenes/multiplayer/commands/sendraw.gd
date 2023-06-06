extends BaseCommand

func _ready():
	var out = ' '.join(PackedStringArray(parameters))
	game.rpc('_submit_raw_message', out, '')

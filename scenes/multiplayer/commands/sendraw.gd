extends BaseCommand

func _init():
	description = "Sends a message into chat without displaying your name."

func _ready():
	var out = ' '.join(PackedStringArray(parameters))
	game.rpc('_submit_raw_message', out, '')

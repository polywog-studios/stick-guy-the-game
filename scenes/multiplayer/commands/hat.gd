extends BaseCommand

func _ready():
	if parameters[0] == 'none':
		game.rpc('remove_player_tag', peer_id, 'hat')
	else:
		game.rpc('add_player_tag', peer_id, 'hat', parameters[0])

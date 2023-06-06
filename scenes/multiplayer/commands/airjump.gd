extends BaseCommand

func _ready():
	if game.players.get_node_or_null(str(peer_id)) != null and game.players.get_node_or_null(str(peer_id)).tags.has('airjump'):
		game.rpc('remove_player_tag', peer_id, 'airjump')
	else:
		game.rpc('add_player_tag', peer_id, 'airjump', true)

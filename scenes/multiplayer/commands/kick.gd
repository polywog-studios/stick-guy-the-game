extends BaseCommand

func _init():
	description = "Instantly kicks another player. (Only works if you have admin)"

func _ready():
	if Global.current_player.is_admin and len(parameters[0]) > 0:
		var player_id:int = int(parameters[0])
		var fuck_u_msg:String = "Player #"+str(player_id)+" isn't a valid player to kill!"
		
		if player_id < 1 or player_id > game.players.get_child_count():
			game._submit_raw_local_message(fuck_u_msg, ":(")
			return # you dumbass
		
		game.MULTIPLAYER_PEER.disconnect_peer(get_player_from_id(player_id).name.to_int())
		pass
	else:
		game._submit_raw_local_message("You are not allowed to perform this action because you aren't the server host.", ">:(")

func get_player_from_id(id:int):
	for player in game.players.get_children():
		player = player as PlayerCharacter
		if player.player_id == id:
			return player
	return null

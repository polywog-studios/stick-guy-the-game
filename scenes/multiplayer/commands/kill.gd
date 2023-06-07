extends BaseCommand

func _init():
	description = "Instantly kill another player (only works if you have admin) or yourself."

func _ready():
	if Global.current_player.is_admin and len(parameters[0]) > 0:
		var player_id:int = int(parameters[0])
		var fuck_u_msg:String = "Player #"+str(player_id)+" isn't a valid player to kill!"
		
		if player_id < 1 or player_id > game.players.get_child_count():
			game._submit_raw_local_message(fuck_u_msg, ":(")
			return # you dumbass
		
		game.rpc("_set_player_property", player_id, "velocity", Vector2.ZERO)
		game.rpc("_set_player_property", player_id, "position", game.get_node('Level/StartPos').position)
	else:
		game.rpc("_set_player_property", Global.current_player.player_id, "velocity", Vector2.ZERO)
		game.rpc("_set_player_property", Global.current_player.player_id, "position", game.get_node('Level/StartPos').position)

extends BaseCommand

func _init():
	description = "Gives another player admin (only works if you're the host)"

func _ready():
	if Global.current_player.is_host:
		rpc("give_admin_to", int(parameters[0]))
	else:
		game._submit_raw_local_message("You are not allowed to perform this action because you aren't the server host.", ">:(")

func get_player_from_id(id:int):
	for player in game.players.get_children():
		player = player as PlayerCharacter
		if player.player_id == id:
			return player
	return null

@rpc("any_peer", "call_local", "reliable")
func give_admin_to(player_id:int):
	var fuck_u_msg:String = "Player #"+str(player_id)+" isn't a valid player to grant to/take from!"
	if player_id < 2: 
		game._submit_raw_local_message(fuck_u_msg if player_id < 1 else "Admin permission cannot be taken away from the host.", ">:(")
		return # you're the host bro what
	
	if player_id > game.players.get_child_count():
		game._submit_raw_local_message(fuck_u_msg, ":(")
		return # you dumbass
		
	var player = get_player_from_id(player_id)
	game.rpc("_set_player_property", player_id, "is_admin", not game._get_player_property(player_id, "is_admin"))
	print(player.is_admin)
	game.rpc("_submit_raw_message", "[color=%s]%s[/color] %s" % [player.sprite.self_modulate.to_html(false), player.player_name+" [#"+str(player.player_id)+"]", "now has admin!" if player.is_admin else "no longer has admin!"], "Given by Player #%s" % Global.current_player.player_id)
	print("Player #%s %s" % [str(player.player_id), "now has admin!" if player.is_admin else "no longer has admin!"])

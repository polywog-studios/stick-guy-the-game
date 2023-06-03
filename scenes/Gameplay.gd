class_name Gameplay extends Node2D

# multiplayer handling logic shits
@onready var main_menu := $MultiplayerGUI/MainMenu
@onready var players := $Players

var MULTIPLAYER_ADDRESS:String = "localhost"
var MULTIPLAYER_PORT:int = 9999
var MULTIPLAYER_USERNAME:String

var MULTIPLAYER_PEER := ENetMultiplayerPeer.new()

func _ready():
	RenderingServer.set_default_clear_color(Color.WHITE)

func start_checking_invalid_state():
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(check_invalid_state)
	add_child(timer)
	timer.start()

func check_invalid_state():
	if players.get_child_count() < 1:
		Global.last_error = "The server host has disconnected!"
		get_tree().change_scene_to_file("res://scenes/menus/ErrorScreen.tscn")

func _on_host_button_pressed():
	main_menu.hide()
	set_default_info()
	Global.player_name = MULTIPLAYER_USERNAME
	
	print('Creating Server %s@%s:%s' % [Global.player_name, MULTIPLAYER_ADDRESS, MULTIPLAYER_PORT])
	
	MULTIPLAYER_PEER.create_server(MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = MULTIPLAYER_PEER
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	start_checking_invalid_state()

func _on_join_button_pressed():
	main_menu.hide()
	set_default_info()
	Global.player_name = MULTIPLAYER_USERNAME
	
	MULTIPLAYER_PEER.create_client(MULTIPLAYER_ADDRESS, MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = MULTIPLAYER_PEER
	
	start_checking_invalid_state()

func add_player(peer_id:int):
	print("Player of ID %s (Peer ID: %s) joined!" % [players.get_child_count() + 1, str(peer_id)])
	
	var player = load("res://characters/player.tscn").instantiate()
	player.name = str(peer_id)
	players.add_child(player)
	
func remove_player(peer_id:int):
	var player:PlayerCharacter = players.get_node_or_null(str(peer_id))
	
	if player != null:
		print("Player of ID %s (Peer ID: %s) left!" % [players.get_child_count(), str(peer_id)])
		player.queue_free()

func set_default_info():
	if MULTIPLAYER_ADDRESS.is_empty():
		MULTIPLAYER_ADDRESS = "localhost"
	if MULTIPLAYER_USERNAME.is_empty():
		MULTIPLAYER_USERNAME = "player_%s" % str(randi_range(0, 99999))

func _on_address_changed(new_text: String) -> void:
	MULTIPLAYER_ADDRESS = new_text

func _on_port_changed(value: float) -> void:
	MULTIPLAYER_PORT = int(value)

func _on_username_changed(new_text: String) -> void:
	MULTIPLAYER_USERNAME = new_text

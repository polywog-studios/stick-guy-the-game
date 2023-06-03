class_name Gameplay extends Node2D

# multiplayer handling logic shits
@onready var main_menu := $MultiplayerGUI/MainMenu
@onready var username_entry := $MultiplayerGUI/MainMenu/MarginContainer/VBoxContainer/UsernameEntry
@onready var address_entry := $MultiplayerGUI/MainMenu/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/AddressEntry
@onready var port_entry := $MultiplayerGUI/MainMenu/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/PortEntry
@onready var players := $Players
@onready var player_list := $HUD/PlayerList/MarginContainer/ScrollContainer/VBoxContainer

const PLAYER = preload("res://characters/player.tscn")

var MULTIPLAYER_ADDRESS:String = "localhost"
var MULTIPLAYER_PORT:int = 9999

var enet_peer := ENetMultiplayerPeer.new()

func _ready():
	RenderingServer.set_default_clear_color(Color.WHITE)
	
func start_checking_invalid_state():
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.timeout.connect(check_invalid_state)
	add_child(timer)
	timer.start()
	
func check_invalid_state():
	if players.get_child_count() < 1:
		Global.last_error = "The server host has disconnected!"
		get_tree().change_scene_to_file("res://scenes/menus/ErrorScreen.tscn")
	
func _on_host_button_pressed():
	main_menu.hide()
	
	Global.player_name = username_entry.text if len(username_entry.text) > 0 else "player_%s" % str(randi_range(0, 99999))
	MULTIPLAYER_ADDRESS = address_entry.text if len(address_entry.text) > 0 else "localhost"
	MULTIPLAYER_PORT = int(port_entry.text) if len(port_entry.text) > 0 else 9999
	
	enet_peer.create_server(MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id())
	
	start_checking_invalid_state()

func _on_join_button_pressed():
	Global.player_name = username_entry.text if len(username_entry.text) > 0 else "player_%s" % str(randi_range(0, 99999))
	main_menu.hide()
	enet_peer.create_client(MULTIPLAYER_ADDRESS, MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = enet_peer
	start_checking_invalid_state()

func add_player(peer_id:int):
	print("Player of ID %s (Peer ID: %s) joined!" % [players.get_child_count() + 1, str(peer_id)])
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	players.add_child(player)
	
func remove_player(peer_id:int):
	var player:PlayerCharacter = players.get_node_or_null(str(peer_id))
	if player != null:
		print("Player of ID %s (Peer ID: %s) joined!" % [players.get_child_count(), str(peer_id)])
		player.queue_free()
	
# local shits
@onready var level:Node2D = $Level
@onready var camera:Camera2D = $Camera2D

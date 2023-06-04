class_name Gameplay extends Node2D

# multiplayer handling logic shits
@onready var main_menu := $MultiplayerGUI/MainMenu
@onready var players := $Players
@onready var chat_box := $HUD/ChatBox
@onready var chat_messages := $HUD/ChatMenu/MarginContainer/ScrollContainer/VBoxContainer
@onready var chat_messages_container := $HUD/ChatMenu/MarginContainer/ScrollContainer

const PLAYER := preload("res://characters/player.tscn")

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
	
	show_hud()
	add_player(multiplayer.get_unique_id())
	
	start_checking_invalid_state()

func _on_join_button_pressed():
	main_menu.hide()
	set_default_info()
	Global.player_name = MULTIPLAYER_USERNAME
	
	MULTIPLAYER_PEER.create_client(MULTIPLAYER_ADDRESS, MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = MULTIPLAYER_PEER
	
	show_hud()
	start_checking_invalid_state()
	
func show_hud():
	$HUD.visible = true

func add_player(peer_id:int):
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	players.add_child(player)
	print("Player #%s joined: %s:%s" % [players.get_child_count(), Global.player_name, str(peer_id)])
	return player
	
func remove_player(peer_id:int):
	var player:PlayerCharacter = players.get_node_or_null(str(peer_id))
	
	if player != null:
		print("Player #%s left: %s:%s" % [players.get_child_count(), Global.player_name, str(peer_id)])
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

@rpc("any_peer", "call_local", "reliable")
func _submit_message(player_name:String, text:String):
	var player:PlayerCharacter = players.get_node_or_null(player_name)
	
	if player == null:
		printerr("Got submitted message with invalid player %s." % player_name)
		return
	
	var message:Label = load("res://scenes/multiplayer/chat_message.tscn").instantiate()
	message.text = "%s > %s" % [player.player_name, text]
	message.modulate = player.sprite.modulate
	message.tooltip_text = "Sent by Player #%s" % player.player_id
	message.name = "message_%s" % chat_messages.get_child_count()
	message.set_multiplayer_authority(player.name.to_int())
	chat_messages.add_child(message, true)
	
	await get_tree().create_timer(0.01).timeout
	chat_messages_container.scroll_vertical = chat_messages.size.y

func _on_chat_message_submitted(new_text:String):
	print("Submitted chat message: %s" % new_text)
	rpc("_submit_message", Global.current_player.name, new_text)
	chat_box.text = ""

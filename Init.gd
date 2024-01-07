extends Node

func _ready():
	if OS.is_debug_build():
		print("Entering dev menu...")
		get_tree().change_scene_to_file.call_deferred("res://debug_tools/DevMenu.tscn")
	else:
		print("Entering main menu...")
		get_tree().change_scene_to_file.call_deferred("res://scenes/MainMenu.tscn")

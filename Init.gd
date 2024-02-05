extends Node

func _ready():
	#if OS.is_debug_build():
		#dev_menu()
	#else:
		#polywog_splash()
	polywog_splash()

func dev_menu():
	print("Entering dev menu...")
	get_tree().change_scene_to_file.call_deferred("res://debug_tools/DevMenu.tscn")
	
func polywog_splash():
	print("Entering Polywog Studios splash...")
	get_tree().change_scene_to_file.call_deferred("res://polywog/Splash.tscn")

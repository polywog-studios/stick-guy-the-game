extends BaseCommand

func _init():
	description = "It clears chat dumbass."

func _ready():
	for i in $'../HUD/ChatMenu/MarginContainer/ScrollContainer/VBoxContainer'.get_children():
		i.queue_free()

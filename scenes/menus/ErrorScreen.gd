class_name ErrorScreen extends Node2D

func _ready():
	$Panel/Description.text = Global.last_error
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("pop in")

func _on_ok_pressed():
	$AnimationPlayer.animation_finished.connect(func(_n:StringName): get_tree().change_scene_to_file("res://scenes/Gameplay.tscn"))
	$AnimationPlayer.play("pop out")

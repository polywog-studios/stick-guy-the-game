class_name Level extends Node2D

@onready var game:Gameplay = $"../"
@onready var death_plane:Area2D = $DeathPlane

func _on_death_plane_body_entered(body):
	if not body is Player:
		return
		
	game.reset_player()

func _process(_delta:float):
	death_plane.position.x = game.player.position.x

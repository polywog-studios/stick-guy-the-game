extends Node2D

@onready var player:Player = $Player
@onready var camera:Camera2D = $Camera

func _physics_process(delta:float):
	camera.position = camera.position.lerp(player.position, delta * 5.0)

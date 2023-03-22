extends Node2D

@onready var level_container:Node = $LevelContainer
@onready var camera:Camera2D = $Camera2D
@onready var player:PlayerCharacter = $Player

var level:Node2D

func _ready():
	RenderingServer.set_default_clear_color(Color.WHITE)
	level = load("res://scenes/levels/Level1.tscn").instantiate()
	level_container.add_child(level)

func _process(delta):
	camera.position = player.position
	
	var limit_x:float = 580
	if player.position.x < limit_x:
		camera.position.x = limit_x
		
	var limit_y:float = 350
	if player.position.y > limit_y:
		camera.position.y = limit_y

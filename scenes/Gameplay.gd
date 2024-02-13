extends Node2D

@onready var player:Player = $Player
@onready var camera:Camera2D = $Camera
@onready var red:Node2D = $Red
@onready var blue:Node2D = $Blue

# may turn this into an enum later,
# for now false = red, true = blue
var color:bool = false:
	set(v):
		red.visible = !v
		blue.visible = v
		player.sprite.modulate = Color.BLUE if v else Color.RED
		color = v

func _physics_process(delta:float):
	camera.position = camera.position.lerp(player.position+player.velocity/4.0-Vector2(0,12), delta * 5.0)

func _process(delta:float):
	if Input.is_action_just_pressed("color_swap"):
		color = !color

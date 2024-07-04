extends Node2D

@onready var player:Player = $Player
@onready var camera:Camera2D = $Camera

@export var _red:NodePath
@export var _blue:NodePath
@export var bg_color:Color

@onready var red:Node2D = get_node(_red)
@onready var blue:Node2D = get_node(_blue)

# may turn this into an enum later,
# for now false = red, true = blue
var color:bool = false:
	set(v):
		red.visible = !v
		blue.visible = v
		player.sprite.modulate = Tools.color_from_bool(v)
		color = v

func _ready():
	RenderingServer.set_default_clear_color(bg_color)

func _physics_process(delta:float):
	camera.position = camera.position.lerp(player.position + (player.velocity / 4.0) - Vector2(0.0, 52.0), delta * 5.0)

func _process(delta:float):
	if Input.is_action_just_pressed("color_swap"):
		color = !color

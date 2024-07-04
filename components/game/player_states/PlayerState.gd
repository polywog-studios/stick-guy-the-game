class_name PlayerState extends StateMachineState

## Whether or not this state is considered a moving state,
## such as walking, running, jumping etc.
@export var is_moving:bool = false

## Whether or not this state is considered a mid-air state,
## such as jumping, falling, etc.
@export var is_mid_air:bool = false

## Node path to the character.
@export_node_path("Player") var _player: NodePath = "../.."

# Reference to the character node.
@onready var player: Player = get_node(_player)
@onready var sprite: AnimatedSprite2D = get_node(_player).get_node("Sprite")
@onready var coyote_timer: Timer = get_node(_player).get_node("CoyoteTimer")

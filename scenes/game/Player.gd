class_name Player extends CharacterBody2D

@onready var sprite:AnimatedSprite2D = $Sprite
@onready var state_machine:FiniteStateMachine = $StateMachine

@export var color:String = "red"

const SPEED = 1800.0
const RUNNING_SPEED = 2500.0
const GRAVITY = 2250.0

var jumps_left:int = 0

func _ready():
	sprite.modulate = Tools.PLAYER_COLORS[color]

func _physics_process(delta:float) -> void:
	if not is_on_floor():
		velocity.y += (GRAVITY * (0.6 if velocity.y < 0.0 else 1.0)) * delta
		if velocity.y >= GRAVITY:
			velocity.y = GRAVITY
	else:
		jumps_left = 2
	
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		jumps_left -= 1
		state_machine.change_state("Jump")
	
	var axis:float = Input.get_axis("move_left", "move_right")
	
	if axis != 0:
		if not is_on_wall() and not ["Jump", "Walk", "Drop"].has(state_machine.current_state.name):
			state_machine.change_state("Walk")
		sprite.flip_h = velocity.x < 0.0
		
	velocity.x += ((SPEED * ((RUNNING_SPEED * 0.001) if Input.is_action_pressed("run") else 1.0)) * axis) * delta
	velocity.x *= 0.9
	
	move_and_slide()

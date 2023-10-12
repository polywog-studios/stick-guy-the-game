class_name Player extends CharacterBody2D

@onready var sprite:AnimatedSprite2D = $Sprite
@onready var state_machine:FiniteStateMachine = $StateMachine

@onready var up_cast:RayCast2D = $UnstuckerUpper/Up
@onready var down_cast:RayCast2D = $UnstuckerUpper/Down
@onready var left_cast:RayCast2D = $UnstuckerUpper/Left
@onready var right_cast:RayCast2D = $UnstuckerUpper/Right

@export var color:String = "red"

signal on_death

const SPEED = 1800.0
const RUNNING_SPEED = 2500.0
const GRAVITY = 2250.0

var jumps_left:int = 0
var wall_stucks:int = 0

var boink_tween:Tween

func _ready():
	sprite.modulate = Tools.PLAYER_COLORS[color]

func _physics_process(delta:float) -> void:
	if not is_on_floor():
		velocity.y += (GRAVITY * (0.6 if velocity.y < 0.0 else 1.0)) * delta
		if velocity.y >= GRAVITY:
			velocity.y = GRAVITY
			
		if not ["Jump", "Fall", "Drop"].has(state_machine.current_state.name) and velocity.y > 100.0:
			state_machine.change_state("Fall")
	else:
		velocity.y = 0.0
		jumps_left = 2
	
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		jumps_left -= 1
		state_machine.change_state("Jump")
	
	var axis:float = Input.get_axis("move_left", "move_right")
	if axis != 0:
		if not is_on_wall() and not ["Fall", "Jump", "Walk", "Drop"].has(state_machine.current_state.name):
			state_machine.change_state("Walk")
		sprite.flip_h = velocity.x < 0.0
		
	velocity.x += ((SPEED * ((RUNNING_SPEED * 0.001) if Input.is_action_pressed("run") else 1.0)) * axis) * delta
	velocity.x *= 0.9
	
	if up_cast.is_colliding() and down_cast.is_colliding() and left_cast.is_colliding() and right_cast.is_colliding():
		wall_stucks += 1
		if wall_stucks >= 250: # if we're stuck for 250 frames kill the player
			on_death.emit()
	else:
		wall_stucks = 0
	
	move_and_slide()

func _on_death(_area):
	on_death.emit()

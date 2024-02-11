class_name PlayerJumpState extends PlayerWalkState

const JUMP_VELOCITY:float = -240.0
const MAX_FALL_VELOCITY:float = 2000.0

var jump_hold:float = 0.0
var falling:bool = false

func on_enter():
	falling = false
	go_idle_at_no_xvel = false
	jump_hold = 0.0
	
	sprite.play(&"Jump")
	player.velocity.y = JUMP_VELOCITY

func on_physics_process(delta:float):
	super(delta)
	if Input.is_action_pressed("jump") and jump_hold < 0.2:
		player.velocity.y = JUMP_VELOCITY
		jump_hold += delta
		
	if player.velocity.y > 0.0 and not falling:
		falling = true
		sprite.play(&"Fall")
		
	if player.is_on_floor():
		change_state("PlayerWalkState")

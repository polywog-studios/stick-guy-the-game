class_name PlayerJumpState extends PlayerWalkState

const JUMP_VELOCITY:float = -240.0
const MAX_FALL_VELOCITY:float = 2000.0

var jump_hold:float = 0.0

func on_enter():
	go_idle_at_no_xvel = false
	jump_hold = 0.0
	
	sprite.speed_scale = 1.0
	sprite.play(&"Jump")
	player.velocity.y = JUMP_VELOCITY
	
	PlayerFallState.coyote_jumped = true

func on_physics_process(delta:float):
	super(delta)
	if jump_hold < 0.2:
		jump_hold += delta
		if Input.is_action_pressed(&"jump"):
			player.velocity.y = JUMP_VELOCITY
		else:
			jump_hold = 0.3
	
	if player.velocity.y > 0.0:
		change_state("PlayerFallState")
	
	if Input.is_action_just_pressed(&"duck"):
		change_state("PlayerStompState")
	
	if player.is_on_floor():
		change_state("PlayerWalkState")

class_name Player extends CharacterBody2D

const SPEED:float = 400.0
const WALK_MAX_SPEED:float = 170.0
const RUN_MAX_SPEED:float = 300.0

const JUMP_VELOCITY:float = -320.0
const MAX_VELOCITY:float = 2000.0
const GRAVITY:float = 1000.0

var jump_hold:float = 0.0

func _physics_process(delta:float):
	if not is_on_floor():
		velocity.y = minf(velocity.y + ((GRAVITY * (1.5 if velocity.y > 0 else 1.0)) * delta), MAX_VELOCITY)
	else:
		jump_hold = 0.0
		
	if Input.is_action_pressed("jump") and jump_hold < 0.1:
		velocity.y = JUMP_VELOCITY
		jump_hold += delta
		
	var axis:float = Input.get_axis("move_left", "move_right")
	if axis != 0.0:
		velocity.x += SPEED * delta * axis
		
		var max_spd:float = (RUN_MAX_SPEED if Input.is_action_pressed("run") else WALK_MAX_SPEED)
		if absf(velocity.x) > max_spd:
			velocity.x = max_spd * signf(velocity.x)
	else:
		velocity.x *= 0.935
		if absf(velocity.x) < 10.0:
			velocity.x = 0.0
		
	move_and_slide()

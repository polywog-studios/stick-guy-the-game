class_name PlayerWalkState extends PlayerState

const SPEED:float = 400.0
const WALK_MAX_SPEED:float = 170.0
const RUN_MAX_SPEED:float = 300.0

var go_idle_at_no_xvel:bool = true

func on_enter():
	sprite.play(&"Walk")

func on_physics_process(delta:float):
	var axis:float = Input.get_axis("move_left", "move_right")
	sprite.flip_h = axis < 0.0
	
	if axis != 0.0:
		player.velocity.x += SPEED * delta * axis
		
		var max_spd:float = (RUN_MAX_SPEED if Input.is_action_pressed("run") else WALK_MAX_SPEED)
		if absf(player.velocity.x) > max_spd:
			player.velocity.x = max_spd * signf(player.velocity.x)
	else:
		player.velocity.x *= 0.935
		if absf(player.velocity.x) < 20.0:
			player.velocity.x = 0.0
			if go_idle_at_no_xvel:
				state_machine.change_state("PlayerIdleState")

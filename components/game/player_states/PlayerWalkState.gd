class_name PlayerWalkState extends PlayerState

const SPEED:float = 400.0
const WALK_MAX_SPEED:float = 170.0
const RUN_MAX_SPEED:float = 300.0

var go_idle_at_no_xvel:bool = true
var skidding:bool = false

func on_enter():
	skidding = false
	sprite.play(&"Run" if Input.is_action_pressed("run") else &"Walk")

func on_physics_process(delta:float):
	var axis:float = Input.get_axis(&"move_left", &"move_right")
	
	if axis != 0.0:
		sprite.flip_h = axis < 0.0
		
		player.velocity.x += SPEED * delta * axis
		player.velocity.x *= 57.6 * delta if skidding and sprite.frame == 0 else 1.0 
		
		var running:bool = Input.is_action_pressed(&"run")
		if not is_mid_air:
			if not skidding:
				sprite.speed_scale = maxf(absf(player.velocity.x) * 0.0085, 0.5)
				sprite.play(&"Run" if running else &"Walk")
			
			if signf(axis) != signf(player.velocity.x):
				skidding = true
				sprite.speed_scale = 1.0
				sprite.play(&"Skid_%s" % (&"Run" if running else &"Walk"))
				sprite.frame = 0
			elif skidding and not sprite.is_playing():
				skidding = false
				sprite.play(&"Run" if running else &"Walk")
		
		var max_spd:float = (RUN_MAX_SPEED if Input.is_action_pressed(&"run") else WALK_MAX_SPEED)
		if absf(player.velocity.x) > max_spd:
			player.velocity.x = max_spd * signf(player.velocity.x)
	else:
		player.velocity.x *= 56.1 * delta
		if absf(player.velocity.x) < 20.0:
			player.velocity.x = 0.0
			if go_idle_at_no_xvel:
				state_machine.change_state("PlayerIdleState")

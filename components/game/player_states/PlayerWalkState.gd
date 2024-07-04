class_name PlayerWalkState extends PlayerState

const SPEED:float = 400.0
const WALK_MAX_SPEED:float = 170.0
const RUN_MAX_SPEED:float = 300.0

var go_idle_at_no_xvel:bool = true

var skidding:bool = false
var has_skidded:bool = false

func on_enter():
	skidding = false
	has_skidded = false
	sprite.play(&"Walk")

func on_physics_process(delta:float):
	var axis:float = Input.get_axis(&"move_left", &"move_right")
	
	if axis != 0.0:
		sprite.flip_h = axis < 0.0
		
		player.velocity.x += SPEED * delta * axis
		player.velocity.x *= 57.6 * delta if skidding and sprite.frame == 0 else 1.0 
		
		var running: bool = Input.is_action_pressed(&"run")
		var play_run_anim: bool = running and absf(player.velocity.x) > 220.0
		
		if not is_mid_air:
			if signf(axis) != signf(player.velocity.x):
				skidding = true
				has_skidded = true
				sprite.speed_scale = 1.0
				sprite.play(&"Skid_%s" % (&"Run" if running else &"Walk"))
				sprite.frame = 0
			
			elif skidding:
				if not sprite.is_playing():
					skidding = false
					sprite.play(&"Run" if running else &"Walk")
			
			else:
				sprite.speed_scale = maxf(absf(player.velocity.x) * 0.0085, 0.5)
				if not has_skidded:
					sprite.play(&"Run" if play_run_anim else &"Walk")
		
		var max_spd:float = (RUN_MAX_SPEED if Input.is_action_pressed(&"run") else WALK_MAX_SPEED)
		if absf(player.velocity.x) > max_spd:
			player.velocity.x = max_spd * signf(player.velocity.x)
	else:
		player.velocity.x *= 56.1 * delta
		
		if go_idle_at_no_xvel:
			var last_frame: int = sprite.frame
			var last_anim: StringName = sprite.animation
			sprite.speed_scale = maxf(absf(player.velocity.x) * 0.0085, 0.5)
			
			var anim: StringName = &"Run" if absf(player.velocity.x) > 180.0 else &"Walk"
			if anim != last_anim:
				sprite.frame = roundi(last_frame * 0.8)
				sprite.play(anim)
		
		if absf(player.velocity.x) < 20.0:
			player.velocity.x = 0.0
			if go_idle_at_no_xvel:
				state_machine.change_state("PlayerIdleState")

class_name PlayerFallState extends PlayerWalkState

func on_enter():
	go_idle_at_no_xvel = false
	sprite.speed_scale = 1.0
	sprite.play(&"Fall")

func on_physics_process(delta:float):
	super(delta)
	if player.is_on_floor():
		change_state("PlayerWalkState")

class_name PlayerFallState extends PlayerWalkState

static var coyote_jumped: bool = false

func on_enter():
	go_idle_at_no_xvel = false
	
	sprite.speed_scale = 1.0
	sprite.play(&"Fall")
	
	coyote_timer.stop()
	coyote_timer.start(0.2)

func on_physics_process(delta:float):
	super(delta)
	if Input.is_action_just_pressed(&"duck"):
		change_state("PlayerStompState")
	
	if player.is_on_floor():
		coyote_jumped = false
		change_state("PlayerWalkState")
	
	if not coyote_jumped and Input.is_action_just_pressed(&"jump") and not coyote_timer.is_stopped():
		coyote_jumped = true
		state_machine.change_state("PlayerJumpState")

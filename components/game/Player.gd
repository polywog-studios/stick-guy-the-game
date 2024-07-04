class_name Player extends CharacterBody2D

const GRAVITY:float = 1000.0

@onready var sm: FiniteStateMachine = $FiniteStateMachine
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var coyote_timer: Timer = $CoyoteTimer

var cs:PlayerState:
	get: return sm.current_state as PlayerState

func _physics_process(delta:float):
	var axis:float = Input.get_axis(&"move_left", &"move_right")
	if axis != 0.0 and not cs.is_moving:
		sm.change_state("PlayerWalkState")
	
	if not is_on_floor():
		velocity.y = minf(velocity.y + ((GRAVITY * (1.5 if velocity.y > 0 else 1.0)) * delta), PlayerJumpState.MAX_FALL_VELOCITY)
		if not cs.is_mid_air:
			sm.change_state("PlayerFallState")
	
	elif Input.is_action_just_pressed(&"jump") and not cs.is_mid_air:
		sm.change_state("PlayerJumpState")
		
	move_and_slide()

class_name PlayerStompState extends PlayerWalkState

const STOMP_VELOCITY: float = 300.0

func on_enter():
	sprite.speed_scale = 1.0
	sprite.play(&"Stomp")
	player.velocity.y = STOMP_VELOCITY
	
func on_physics_process(delta: float):
	super(delta)
	if player.is_on_floor():
		sprite.scale = Vector2(1.5, 0.5)
		
		var tween: Tween = get_tree().create_tween().set_parallel()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.5)
		
		change_state("PlayerWalkState")

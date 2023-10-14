class_name WallSlideState extends CharacterState

func on_enter() -> void:
	var sprite:AnimatedSprite2D = character.get_node("Sprite")
	sprite.play("wall_slide")
	sprite.speed_scale = 1.0

func on_process(delta:float) -> void:
	character.jumps_left = 2
	
	if character.velocity.y >= 0 and character.is_on_floor():
		change_state("Walk")

func on_physics_process(delta:float) -> void:
	if Input.is_action_pressed("jump"):
		change_state("Jump")
	else:
		character.velocity.y = Player.GRAVITY * 0.05

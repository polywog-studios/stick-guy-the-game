class_name IdleState extends CharacterState

func on_enter() -> void:
	var sprite:AnimatedSprite2D = character.get_node("Sprite")
	sprite.play("idle")
	sprite.speed_scale = 1.0
	
func on_physics_process(_delta:float) -> void:
	if Input.is_action_just_pressed("duck"):
		change_state("Duck")

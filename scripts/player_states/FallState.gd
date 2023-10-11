class_name FallState extends CharacterState

func on_enter() -> void:
	character.sprite.frame = 0
	character.sprite.play("fall")
	character.sprite.speed_scale = 1.0

func on_process(_delta:float) -> void:
	if character.velocity.y >= 0 and character.is_on_floor():
		change_state("Walk")
		
func on_physics_process(_delta:float):
	if Input.is_action_just_pressed("duck"):
		change_state("Drop")

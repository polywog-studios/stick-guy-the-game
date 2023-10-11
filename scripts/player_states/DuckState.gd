class_name DuckState extends CharacterState

func on_enter() -> void:
	character.sprite.play("duck")
	character.sprite.speed_scale = 1.0

func on_physics_process(_delta:float) -> void:
	if Input.is_action_just_released("duck"):
		change_state("Idle")

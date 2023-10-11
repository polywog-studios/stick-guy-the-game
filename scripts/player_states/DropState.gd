class_name DropState extends CharacterState

@export var DROP_VELOCITY = 700.0

func on_enter() -> void:
	character.sprite.play("drop")
	character.sprite.speed_scale = 1.0
	character.velocity.y = DROP_VELOCITY

func on_process(_delta:float) -> void:
	if character.velocity.y >= 0 and character.is_on_floor():
		change_state("Walk")

class_name DropState extends CharacterState

@export var DROP_VELOCITY = 700.0

func on_enter() -> void:
	character.sprite.play("drop")
	character.sprite.speed_scale = 1.0
	character.velocity.y = DROP_VELOCITY

func on_process(_delta:float) -> void:
	if character.velocity.y >= 0 and character.is_on_floor():
		character.sprite.scale = Vector2(2, 0.25)
		
		if is_instance_valid(character.boink_tween):
			character.boink_tween.stop()
		
		var tween:Tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(character.sprite, "scale", Vector2.ONE, 1.0)
		character.boink_tween = tween
		
		change_state("Walk")

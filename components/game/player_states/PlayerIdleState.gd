class_name PlayerIdleState extends PlayerState

func on_enter():
	sprite.speed_scale = 1.0
	sprite.play(&"Idle")

func on_physics_process(_delta:float):
	if Input.is_action_just_pressed(&"duck"):
		sprite.play(&"Duck")
	elif Input.is_action_just_released(&"duck"):
		sprite.play(&"Idle")

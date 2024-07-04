class_name PlayerIdleState extends PlayerState

var ducking:bool = false

func on_enter():
	ducking = false
	sprite.speed_scale = 1.0
	sprite.play(&"Idle")

func on_physics_process(_delta:float):
	if Input.is_action_pressed(&"duck") and not ducking:
		ducking = true
		sprite.play(&"Duck")
	
	elif Input.is_action_just_released(&"duck"):
		ducking = false
		sprite.play(&"Idle")

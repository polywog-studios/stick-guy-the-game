extends AnimatedSprite2D

var shit:float = 0.0

func _process(delta:float):
	shit += delta * 2.0
	if shit >= 1000.0:
		shit = 0.0
	offset.y = sin(shit) * 5

func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		queue_free()

extends Level

func _ready():
	for ind in $Indicators.get_children():
		if ind is AnimatedSprite2D:
			ind.play("default")

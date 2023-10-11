class_name ColorPickerSquare extends Control

@onready var sprite:Sprite2D = $Sprite

var selected:bool = false

func _process(delta:float):
	sprite.frame = 1 if selected else 0
	sprite.scale = sprite.scale.lerp(Vector2(1.5, 1.5) if selected else Vector2(1.3, 1.3), delta * 20.0)

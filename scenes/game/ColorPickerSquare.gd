class_name ColorPickerSquare extends Control

@onready var sprite:Sprite2D = $Sprite

var selected:bool = false:
	set(v):
		$Sprite.frame = int(v)
		selected = v

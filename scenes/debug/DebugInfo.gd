extends Control

@onready var balls:Label = $Balls

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return

func _update() -> void:
	balls.text = '%s fps' % [Engine.get_frames_per_second()]

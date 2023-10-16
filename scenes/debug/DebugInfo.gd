extends Control

@onready var balls:Label = $Balls

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	_update()

func _update() -> void:
	balls.text = '%s fps - %smb' % [Engine.get_frames_per_second(), "%.2f" % (OS.get_static_memory_usage()/1000000.0)]

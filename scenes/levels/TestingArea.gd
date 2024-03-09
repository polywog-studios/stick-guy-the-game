extends Node2D

@onready var watcher = $SubViewportContainer/SubViewport/MeshInstance3D
@onready var gameplay = $Gameplay

func _process(delta):
	watcher.look_at(Vector3(380-gameplay.player.position.x-190,gameplay.player.position.y-126,0))

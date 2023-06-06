class_name BaseCommand extends Node

var parameters:PackedStringArray
var peer_id:int
@onready var game:Gameplay = $"../"
@export_multiline var description:String = "No description available"
	
func _physics_process(_delta:float):
	queue_free()

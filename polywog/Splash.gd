class_name PolywogSplash extends ColorRect

@onready var jingle:AudioStreamPlayer = $Jingle

@onready var lilypads:TextureRect = $Lilypads
@onready var frog:Sprite2D = $Frog
@onready var polywog_text:Sprite2D = $PolywogText
@onready var studios_text:Sprite2D = $StudiosText

@onready var flash:ColorRect = $Flash
@onready var transition:Sprite2D = $Transition

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.5).timeout
	jingle.play()
	
	frog.visible = true
	await get_tree().create_timer(0.3).timeout
	polywog_text.visible = true
	
	await get_tree().create_timer(0.3).timeout
	studios_text.visible = true
	
	await get_tree().create_timer(0.3).timeout
	lilypads.visible = true
	flash.modulate.a = 1.0
	
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(flash, "modulate:a", 0.0, 0.5)
	
	await get_tree().create_timer(2.0).timeout
	Tools.change_scene_to_file("res://scenes/MainMenu.tscn")

func _process(delta:float):
	if lilypads.visible:
		lilypads.position.x -= delta * 20 * 1.0
		lilypads.position.y -= delta * 20 * 0.5

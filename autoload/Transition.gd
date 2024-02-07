extends CanvasLayer

signal transitioned(inwards:bool)

@onready var sprite:ColorRect = $Sprite

var trans_scale:float = 0.0

func trans_in():
	sprite.visible = true
	trans_scale = 0.0
	
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "trans_scale", 1.0, 1.0)
	
	await get_tree().create_timer(1.05).timeout
	transitioned.emit(true)
	
func _process(_delta:float):
	var material := sprite.material as ShaderMaterial
	material.set_shader_parameter("scale", trans_scale)
	
func trans_out():
	sprite.visible = true
	trans_scale = 1.0
	#sprite.scale = Vector2.ONE * 1.75
	
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "trans_scale", 0.0, 1.0)
	
	await get_tree().create_timer(1.05).timeout
	transitioned.emit(false)

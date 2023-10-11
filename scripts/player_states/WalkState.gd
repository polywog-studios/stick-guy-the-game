class_name WalkState extends CharacterState

@onready var current_scene:Node = get_tree().current_scene
@onready var trail_timer:Timer = $TrailTimer

func running_trail() -> void:
	if not (Input.is_action_pressed("run") and absf(character.velocity.x) > 20.0):
		return
	
	var trail:AnimatedSprite2D = character.sprite.duplicate()
	trail.position = character.position
	trail.modulate.a = 0.6
	trail.pause()
	current_scene.add_child(trail)
	
	var tween:Tween = create_tween()
	tween.tween_property(trail, "modulate:a", 0.0, 0.7)
	tween.tween_callback(trail.queue_free)

func update_anim() -> void:
	character.sprite.play("run" if Input.is_action_pressed("run") else "walk")

func on_enter() -> void:
	update_anim()
	
func _ready():
	trail_timer.timeout.connect(running_trail)

func on_physics_process(_delta:float) -> void:
	character.sprite.speed_scale = absf(character.velocity.x) * 0.006
	
	if Input.is_action_just_pressed("run") or Input.is_action_just_released("run"):
		update_anim()
		
	var axis:float = Input.get_axis("move_left", "move_right")
	if character.is_on_wall() or (axis == 0 and absf(character.velocity.x) < 20.0):
		change_state("Idle")

class_name PlayerCharacter extends CharacterBody2D

@export var SPEED = 80.0
@export var BOOST_SPEED = 165.0

@export var JUMP_VELOCITY = -500.0

@onready var sprite := $sprite
@onready var hitbox := $hitbox
@onready var nametag := $nametag
@onready var type_icon := $nametag/type
@onready var camera:Camera2D = $"../../Camera2D"
@onready var color_picker := $ColorPicker

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor:bool = false
var ducking:bool = false

var jump_hold:float = 0
# max is 5
var coyote_frames:int = 0
var quick_falling:bool = false

# this is a shit way of storing player info
# since it can be exploited
# but i'm making this for fun anyways
# if this turns into a full blown game then i'll
# worry about this later on
@export var player_name:String = "???"
@export var player_id:int = -1
@export var is_host:bool = false

func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func _ready():
	nametag.modulate.a = 0.0
	
	position = $"../../Level/StartPos".global_position
	player_name = Global.player_name
	player_id = $"../../Players".get_child_count()
	is_host = player_id < 2
	
	if not is_multiplayer_authority(): return
	Global.current_player = self
	sprite.play("jump" if !is_on_floor() else "idle")
	camera.enabled = true
	camera.make_current()
	
	color_picker.color = sprite.modulate
	
func _unhandled_key_input(event:InputEvent):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("change_color"):
		color_picker.visible = not color_picker.visible
		
	if Input.is_action_just_pressed("hide_nametag"):
		nametag.visible = not nametag.visible

func _process(delta):
	nametag.text = "%s • #%s" % [player_name, str(player_id)]
	nametag.size.x = 0
	type_icon.play("host" if is_host else "player")
	nametag.position.x = lerpf(nametag.position.x, nametag.size.x * -0.5, delta * 5.0)
	nametag.modulate.a = lerpf(nametag.modulate.a, 1.0, delta * 5.0)
	
	color_picker.position.x = nametag.position.x + 15
	color_picker.position.y = nametag.position.y - 95

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		coyote_frames += 1
	else:
		coyote_frames = 0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if on_floor != is_on_floor():
			sprite.play("jump")
			on_floor = is_on_floor()
	elif on_floor != is_on_floor():
		if quick_falling:
			sprite.scale = Vector2(3, 1)
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(sprite, "scale", Vector2(2, 2), 0.5)
			
		quick_falling = false
		sprite.play("idle")
		on_floor = is_on_floor()
		
	# Handle Duck (quack).
	if !ducking and Input.is_action_just_pressed("duck") and is_on_floor():
		ducking = true
		sprite.play("duck")
		hitbox.shape.size.y = 39
		hitbox.position.y = 15 + (hitbox.shape.size.y * 0.5)
		
	if ducking and Input.is_action_just_released("duck") and is_on_floor():
		ducking = false
		sprite.play("idle")
		hitbox.shape.size.y = 78
		hitbox.position.y = 15
		
	# Quick Falling
	if Input.is_action_just_pressed("duck") and not is_on_floor():
		quick_falling = true
		velocity.y = 850
		sprite.play("quick_fall")

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_frames <= 8):
		jump_hold = 2.5
		sprite.play("jump")
		on_floor = false
		
	if Input.is_action_pressed("jump") and not on_floor:
		velocity.y += JUMP_VELOCITY * (clampf(jump_hold, 0, 1) * 0.275)
		jump_hold = lerpf(jump_hold, 0, 0.33)
		
	var play_walk_shit:bool = absf(velocity.x) > 50

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction:int = Input.get_axis("move_left", "move_right")
	var boosting:bool = Input.is_action_pressed("boost")
	velocity.x += direction * (BOOST_SPEED if boosting else SPEED)
	sprite.speed_scale = (2.0 if boosting and on_floor and play_walk_shit else 1.0)
	
	if direction != 0:
		sprite.flip_h = true if direction < 0 else false
	
	if on_floor:
		if play_walk_shit:
			ducking = false
			sprite.play("walk")
		elif not ducking:
			sprite.play("idle")
			
	velocity.x *= 0.85
	move_and_slide()
	
	camera.position = position
	
	var limit_x:float = 640
	if position.x < limit_x:
		camera.position.x = limit_x
		
	var limit_y:float = 310
	if position.y > limit_y:
		camera.position.y = limit_y

func _on_color_picker_color_changed(color:Color):
	sprite.modulate = color

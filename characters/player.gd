class_name PlayerCharacter extends CharacterBody2D

@export var SPEED := 80.0
@export var BOOST_SPEED := 165.0

@export var JUMP_VELOCITY := -500.0

@onready var sprite := $sprite
@onready var hitbox := $hitbox
@onready var nametag := $nametag
@onready var type_icon := $nametag/type
@onready var game:Gameplay = $"../../"
@onready var camera:Camera2D = $"../../Camera2D"
@onready var color_picker := $ColorPicker
@onready var hat := $sprite/hat
@onready var left_wall := $LeftWall
@onready var right_wall := $RightWall

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor:bool = false
var ducking:bool = false

var jump_hold:float = 0
# max is 8
var coyote_frames:int = 0
var quick_falling:bool = false

var boost_frames:int = 0
var wall_sliding:bool = false
@export var boosting:bool = false

# this is a shit way of storing player info
# since it can be exploited
# but i'm making this for fun anyways
# if this turns into a full blown game then i'll
# worry about this later on
@export var player_name:String = "???":
	set(value):
		player_name = value
		update_nametag()
@export var player_id:int = -1:
	set(value):
		player_id = value
		update_nametag()
@export var is_host:bool = false
@export var is_admin:bool = false

@export var tags := {}

func update_nametag():
	if nametag:
		nametag.text = "%s - #%s" % [player_name, str(player_id)]
		nametag.size.x = 0

func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func _ready():
	nametag.modulate.a = 0.0
	
	position = $"../../Level/StartPos".global_position
	player_name = Global.player_name
	game.rpc("add_player_tag", name.to_int(), "hat", tags["hat"] if tags.has("hat") else null)
	
	if not is_multiplayer_authority(): return
	Global.current_player = self
	nametag.z_index = 1
	sprite.play("jump" if !is_on_floor() else "idle")
	camera.enabled = true
	camera.make_current()
	
	color_picker.color = sprite.self_modulate
	
	game.rpc("_submit_raw_message", "[color=%s]%s[/color] joined the game!" % [sprite.self_modulate.to_html(false), player_name], "Sent by Player #%s" % game.players.get_child_count())
	print("Player #%s joined: %s:%s" % [game.players.get_child_count(), player_name, name])
	
func _unhandled_key_input(_event:InputEvent):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("change_color"):
		color_picker.visible = not color_picker.visible
		
	if Input.is_action_just_pressed("hide_nametag"):
		nametag.visible = not nametag.visible

func _process(delta):
	type_icon.play("host" if is_host else "player")
	nametag.position.x = lerpf(nametag.position.x, nametag.size.x * -0.5, delta * 5.0)
	nametag.modulate.a = lerpf(nametag.modulate.a, 1.0, delta * 5.0)
	
	color_picker.position.x = -40 # *rages*
	color_picker.position.y = nametag.position.y - 95
	
	if tags.has('gay'):
		sprite.self_modulate.h += delta
		color_picker.color.h = sprite.self_modulate.h
	if sprite.animation == 'duck' or sprite.animation == 'jump':
		hat.offset.y = -12
	else:
		hat.offset.y = -25
		
func handle_coyote_frames():
	if not is_on_floor():
		coyote_frames += 1
	else:
		coyote_frames = 0
		
func handle_boosting():
	if boosting:
		boost_frames += 1
		if boost_frames >= 3:
			var trail := sprite.duplicate()
			trail.is_trail = true
			trail.global_position = sprite.global_position
			trail.frame = sprite.frame
			game.add_child(trail)
			boost_frames = 0
	else:
		boost_frames = 0
		
func handle_falling(delta:float):
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
		
func handle_ducking():
	if not game.chat_box.has_focus() and not game.settings_username_entry.has_focus() and not ducking and Input.is_action_just_pressed("duck") and is_on_floor():
		ducking = true
		sprite.play("duck")
		hitbox.shape.size.y = 39
		hitbox.position.y = 15 + (hitbox.shape.size.y * 0.5)
		
	if not game.chat_box.has_focus() and not game.settings_username_entry.has_focus() and ducking and Input.is_action_just_released("duck") and is_on_floor():
		ducking = false
		sprite.play("idle")
		hitbox.shape.size.y = 78
		hitbox.position.y = 15
		
func handle_quick_falling():
	if not game.chat_box.has_focus() and not game.settings_username_entry.has_focus() and Input.is_action_just_pressed("duck") and not is_on_floor():
		quick_falling = true
		velocity.y = 850
		sprite.play("quick_fall")
		
func handle_jumping(direction:float):
	if not game.chat_box.has_focus() and not game.settings_username_entry.has_focus() and Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_frames <= 8 or wall_sliding or tags.has('airjump')):
		jump_hold = 2.5 * (1.3 if wall_sliding else 1.0)
		sprite.play("jump")
		on_floor = false
		if wall_sliding:
			velocity.x = (1 if sprite.flip_h else -1) * 700
			sprite.flip_h = not sprite.flip_h
		
	if not game.chat_box.has_focus() and not game.settings_username_entry.has_focus() and Input.is_action_pressed("jump") and not on_floor:
		velocity.y += JUMP_VELOCITY * (clampf(jump_hold, 0, 1) * 0.275)
		jump_hold = lerpf(jump_hold, 0, 0.33)
		
func handle_wall_sliding():
	var old_sliding:bool = wall_sliding
	wall_sliding = (left_wall.is_colliding() or right_wall.is_colliding()) and not is_on_ceiling() and not on_floor
	if wall_sliding:
		velocity.y *= 0.9
	else:
		if old_sliding != wall_sliding:
			sprite.play("jump")
		
func handle_walking(direction:float, play_walk_shit:bool):
	boosting = Input.is_action_pressed("boost") and not game.chat_box.has_focus() and not game.settings_username_entry.has_focus()
	velocity.x += direction * (BOOST_SPEED if boosting == true else SPEED)
	sprite.speed_scale = (2.0 if boosting and on_floor and play_walk_shit else 1.0)

func handle_animations(direction:float, play_walk_shit:bool):
	if direction != 0:
		sprite.flip_h = true if direction < 0 else false
		sprite.hat.flip_h = sprite.flip_h
	
	if on_floor:
		if play_walk_shit:
			ducking = false
			sprite.play("walk")
		elif not ducking:
			sprite.play("idle")
	else:
		if wall_sliding:
			sprite.play("wall_slide")
			
func handle_velocity():
	velocity.x *= 0.85
	move_and_slide()
			
func handle_camera():
	camera.position = position
	
	var limit_x:float = 640
	if position.x < limit_x:
		camera.position.x = limit_x
		
	var limit_y:float = 310
	if position.y > limit_y:
		camera.position.y = limit_y

func _physics_process(delta:float):
	handle_coyote_frames()
	handle_boosting()
		
	if not is_multiplayer_authority(): return
	var direction:float = Input.get_axis("move_left", "move_right") if not game.chat_box.has_focus() and not game.settings_username_entry.has_focus() else 0.0
	
	handle_falling(delta)
	handle_ducking()
	handle_quick_falling()
	handle_jumping(direction)
	handle_wall_sliding()
	
	var play_walk_shit:bool = absf(velocity.x) > 50
	handle_walking(direction, play_walk_shit)
	handle_animations(direction, play_walk_shit)
	handle_velocity()
	handle_camera()

func _on_color_picker_color_changed(color:Color):
	sprite.self_modulate = color

func _on_death_detector_area_entered(_area):
	position = game.get_node('Level/StartPos').position

func tag_changed(tag:String, value:Variant):
	match tag:
		"hat":
			if value:
				hat.texture = load("res://images/hats/%s.png" % value)
			else:
				hat.texture = null

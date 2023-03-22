extends CharacterBody2D

class_name PlayerCharacter

@export var SPEED = 80.0
@export var BOOST_SPEED = 140.0

@export var JUMP_VELOCITY = -500.0

@onready var sprite = $sprite
@onready var hitbox = $hitbox

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor:bool = false
var ducking:bool = false

var jump_hold:float = 0

func _ready():
	sprite.play("jump" if !is_on_floor() else "idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if on_floor != is_on_floor():
			sprite.play("jump")
			on_floor = is_on_floor()
			
	elif on_floor != is_on_floor():
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

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_hold = 2.5
		
	if Input.is_action_pressed("ui_accept"):
		velocity.y += JUMP_VELOCITY * (clampf(jump_hold, 0, 1) * 0.275)
		if sprite.animation != "jump" and !is_on_floor():
			sprite.play("jump")
		on_floor = false
		jump_hold = lerpf(jump_hold, 0, 0.33)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction:int = Input.get_axis("ui_left", "ui_right")
	var boosting:bool = Input.is_key_pressed(KEY_SHIFT)
	velocity.x += direction * (BOOST_SPEED if boosting else SPEED)
	sprite.speed_scale = (2 if boosting else 1.0)
	
	if direction != 0:
		sprite.flip_h = true if direction < 0 else false
	
	if on_floor:
		if absf(velocity.x) > 50:
			ducking = false
			sprite.play("walk")
		elif not ducking:
			sprite.play("idle")
			
	velocity.x *= 0.85
	move_and_slide()

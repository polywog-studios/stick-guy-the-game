extends CharacterBody2D

class_name PlayerCharacter

@export var SPEED = 80.0
@export var BOOST_SPEED = 140.0

@export var JUMP_VELOCITY = -500.0

@onready var sprite = $sprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor:bool = false

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

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")
		on_floor = false	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction:int = Input.get_axis("ui_left", "ui_right")
	var boosting:bool = Input.is_key_pressed(KEY_SHIFT)
	velocity.x += direction * (BOOST_SPEED if boosting else SPEED)
	sprite.speed_scale = (1.5 if boosting else 1.0)
	
	if direction != 0:
		sprite.flip_h = true if direction < 0 else false
	
	if on_floor:
		if absf(velocity.x) > 50:
			sprite.play("walk")
		else:
			sprite.play("idle")
			
	velocity.x *= 0.85
	move_and_slide()

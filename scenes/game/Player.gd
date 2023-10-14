class_name Player extends CharacterBody2D

@onready var sprite:AnimatedSprite2D = $Sprite
@onready var state_machine:FiniteStateMachine = $StateMachine

@onready var wall_check:Area2D = $WallCheck

@onready var nametag_bg:NinePatchRect = $NameTag
@onready var nametag_label:Label = $NameTag/Label

@export var color:String = "red":
	set(v):
		# Only temporary, ya can change how this works later
		
		set_collision_layer_value(Tools.PLAYER_COLORS.keys().find(color) + 2, false)
		set_collision_mask_value(Tools.PLAYER_COLORS.keys().find(color) + 2, false)
		
		wall_check.set_collision_layer_value(Tools.PLAYER_COLORS.keys().find(color) + 2, false)
		wall_check.set_collision_mask_value(Tools.PLAYER_COLORS.keys().find(color) + 2, false)
		
		color = v
		
		set_collision_layer_value(Tools.PLAYER_COLORS.keys().find(color) + 2, true)
		set_collision_mask_value(Tools.PLAYER_COLORS.keys().find(color) + 2, true)
		
		wall_check.set_collision_layer_value(Tools.PLAYER_COLORS.keys().find(color) + 2, true)
		wall_check.set_collision_mask_value(Tools.PLAYER_COLORS.keys().find(color) + 2, true)

signal on_death

const SPEED = 900.0
const RUNNING_SPEED = 2250.0
const GRAVITY = 1125.0

var jumps_left:int = 0
var wall_stucks:int = 0

var boink_tween:Tween
var nametag_visible:bool = true

func _ready() -> void:
	sprite.modulate = Tools.COLORS[color]

func _physics_process(delta:float) -> void:
	var not_sliding:bool = wall_check.get_overlapping_bodies().size() < 2
	
	if not is_on_floor():
		if wall_check.get_overlapping_bodies().size() > 1:
			if state_machine.current_state.name != "WallSlide" and velocity.y < 0:
				state_machine.change_state("WallSlide")
		else:
			velocity.y += (GRAVITY * (0.6 if velocity.y < 0.0 else 1.0)) * delta
			if velocity.y >= GRAVITY:
				velocity.y = GRAVITY
			
			if not ["Jump", "Fall", "Drop"].has(state_machine.current_state.name) and velocity.y > 100.0:
				state_machine.change_state("Fall")
	else:
		velocity.y = 0.0
		jumps_left = 2
	
	var axis:float = Input.get_axis("move_left", "move_right")
	
	velocity.x += ((SPEED * ((RUNNING_SPEED * 0.001) if Input.is_action_pressed("run") else 1.0)) * axis) * delta
	velocity.x *= 0.9
	
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		if state_machine.current_state.name == "WallSlide":
			velocity.x += SPEED * 25.0 * -axis * delta
		
		jumps_left -= 1
		state_machine.change_state("Jump")
	
	if axis != 0:
		if not_sliding and not ["Fall", "Jump", "Walk", "Drop"].has(state_machine.current_state.name):
			state_machine.change_state("Walk")
		
		sprite.flip_h = velocity.x < 0.0
	
	# Gonna replace this for a button in the menu for level restarting
#	if up_cast.is_colliding() and down_cast.is_colliding() and left_cast.is_colliding() and right_cast.is_colliding():
#		wall_stucks += 1
#		if wall_stucks >= 250: # if we're stuck for 250 frames kill the player
#			on_death.emit()
#	else:
#		wall_stucks = 0
		
	if Input.is_action_just_pressed("nametag_toggle"):
		nametag_visible = not nametag_visible
	
	move_and_slide()
	
func _process(delta:float):
	nametag_bg.size.x = (nametag_label.size.x * nametag_label.scale.x)+7
	nametag_bg.position.x = (nametag_bg.size.x * nametag_bg.scale.x) * -0.5
	nametag_bg.modulate.a = lerpf(nametag_bg.modulate.a, 1.0 if nametag_visible else 0.0, delta * 10.0)

func _on_death(_area):
	on_death.emit()

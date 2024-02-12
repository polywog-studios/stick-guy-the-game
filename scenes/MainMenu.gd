extends Control

var selected := 0:
	set(v):
		selected = v
		$Point.position.y = 148+v*24

var functions = [
	func(): Tools.change_scene_to_file('res://scenes/Gameplay.tscn'),
	func(): print('not implemented'),
	func(): print('not implemented'),
	func(): print('not implemented')
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('ui_down'):
		selected = wrap(selected+1,0,4)
	if Input.is_action_just_pressed('ui_up'):
		selected = wrap(selected-1,0,4)
	if Input.is_action_just_pressed('ui_accept'):
		functions[selected].call()

var secret_code = 'luigi'
var secret_state = 0

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.unicode == secret_code.unicode_at(min(secret_state,secret_code.length()-1)):
				secret_state += 1
				if secret_state == secret_code.length():
					secret()
			elif event.unicode != 0:
				secret_state = 0

func secret():
	create_tween().tween_property($Luigi, 'position:y', 228, 0.5)

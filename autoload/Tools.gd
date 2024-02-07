extends Node

func _ready():
	RenderingServer.set_default_clear_color(Color.WHITE)

## Returns Color.BLUE if the given bool is true,
## Returns Color.RED if the given bool is false.
func color_from_bool(boolean:bool) -> Color:
	return Color.BLUE if boolean else Color.RED

## Changes the current scene to a one from
## a given file path, optionally with a transition.
func change_scene_to_file(file_path:String, transition:bool = true):
	if transition:
		Transition.transitioned.connect(func(inwards:bool):
			get_tree().change_scene_to_file(file_path)
			Transition.trans_out.call_deferred()
		, Object.CONNECT_ONE_SHOT)
		Transition.trans_in()
	else:
		get_tree().change_scene_to_file(file_path)

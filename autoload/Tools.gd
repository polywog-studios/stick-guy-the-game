extends Node

func _ready():
	RenderingServer.set_default_clear_color(Color.WHITE)

## Returns Color.BLUE if the given bool is true,
## Returns Color.RED if the given bool is false.
func color_from_bool(boolean:bool) -> Color:
	return Color.BLUE if boolean else Color.RED

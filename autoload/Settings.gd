extends Node

const SAVE_CFG_PATH:String = "user://settings.cfg"

var data:Dictionary = {
	"fullscreen": false,
	"window_size": 3, # this is a multiplier
	"master_volume": 1.0, # multiplier from 0 to 1
}
var _cfg:ConfigFile = ConfigFile.new()

func _ready():
	if FileAccess.file_exists(SAVE_CFG_PATH):
		fetch()
	else:
		create()
	
func apply_setting(setting:String):
	match setting:
		"fullscreen":
			get_window().mode = Window.MODE_FULLSCREEN if data.fullscreen else Window.MODE_WINDOWED
			
		"window_size":
			var screen_rect:Rect2i = DisplayServer.screen_get_usable_rect()
			var size_mult:int = int(data.window_size)
			var window:Window = get_window()
			window.size = Vector2i(380 * size_mult, 252 * size_mult)
			window.position = (screen_rect.size - window.size) * 0.5
			
		"master_volume":
			var master_bus:int = AudioServer.get_bus_index("Master")
			AudioServer.set_bus_volume_db(master_bus, linear_to_db(data.master_volume))
	
func create():
	print("Making new save data...")
	
	for prop in data.keys():
		_cfg.set_value("Settings", prop, data[prop])
		print("%s initialized" % prop)
	
	_cfg.save(SAVE_CFG_PATH)

func fetch():
	print("Fetching settings...")
	
	var invoke_save:bool = false
	_cfg.load(SAVE_CFG_PATH)
	
	for prop in data.keys():
		if _cfg.has_section_key("Settings", prop):
			data[prop] = _cfg.get_value("Settings", prop)
			print("%s loaded" % prop)
		else:
			invoke_save = true
			_cfg.set_value("Settings", prop, data[prop])
			print("%s not present, initializing it" % prop)
			
		apply_setting(prop)
	
	if invoke_save:
		_cfg.save(SAVE_CFG_PATH)

func save():
	print("Saving settings...")
	
	for prop in data.keys():
		_cfg.set_value("Settings", prop, data[prop])
		
	_cfg.save(SAVE_CFG_PATH)

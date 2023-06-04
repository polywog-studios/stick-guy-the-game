extends Node

const _json_path:String = "user://guy_settings.json"
var _settings:Dictionary = {
	"username": "",
	"address": "",
	"port": "9999"
}

func _ready():
	var json:Dictionary = {}
	
	if not ResourceLoader.exists(_json_path):
		var f = FileAccess.open(_json_path, FileAccess.WRITE)
		f.store_string("{}")
	else:
		var f = FileAccess.open(_json_path, FileAccess.READ)
		if f.get_as_text() == null or len(f.get_as_text()) < 1:
			json = {}
		else:
			json = JSON.parse_string(f.get_as_text())
		
	for key in _settings:
		if not key in json:
			json[key] = _settings[key]
			print(key+" not present, creating it!")
		else:
			_settings[key] = json[key]
			print(key+" initialized successfully!")
			
	var f = FileAccess.open(_json_path, FileAccess.WRITE)
	f.store_string(JSON.stringify(json))
	
	update_settings()
	
	print("Initialized settings!")
	
func update_settings() -> void:
	pass

func get_setting(_name:String):
	if _name in _settings:
		return _settings[_name]
		
	return null
	
func set_setting(_name:String, value:Variant):
	_settings[_name] = value
	
func flush():
	var file := FileAccess.open(_json_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(_settings))

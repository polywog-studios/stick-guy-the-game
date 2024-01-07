class_name DevBooleanSetting extends DevSetting

## Converts stuff like value, minimum, maximum, etc
## to a human-readable format
func data_to_string() -> String:
	return "[value: %s]" % [Settings.data[name]]

func toggle():
	Settings.data[name] = not Settings.data[name]
	Settings.apply_setting(name)
	Settings.save()

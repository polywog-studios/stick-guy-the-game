@tool
extends EditorPlugin

func _enter_tree():
	add_tool_menu_item('Aseprite Spritesheet to Resource', func():
		for i in get_editor_interface().get_selected_paths():
			convert_json(i)
	)

func _exit_tree():
	remove_tool_menu_item('Aseprite Spritesheet to Resource')

func convert_json(path:String):
	if path.get_extension() != 'json': return
	if !FileAccess.file_exists(path): return
	var json_file = FileAccess.open(path,FileAccess.READ)
	var json = JSON.parse_string(json_file.get_as_text())
	
	if !FileAccess.file_exists(path.get_base_dir() + '/' + json.meta.image): return
	var image = load(path.get_base_dir() + '/' + json.meta.image)
	
	var frame_array = json.frames if (json.frames is Array) else json.frames.values()
	
	var frames = SpriteFrames.new()
	frames.remove_animation("default")
	
	for anim in json.meta.frameTags:
		for i in range(anim.from, anim.to + 1):
			var frame = AtlasTexture.new()
			frame.atlas = image
			frame.region = Rect2(
				frame_array[i].frame.x, frame_array[i].frame.y,
				frame_array[i].frame.w, frame_array[i].frame.h
			)
			frame.margin = Rect2(
				frame_array[i].spriteSourceSize.x, frame_array[i].spriteSourceSize.y,
				frame_array[i].sourceSize.w-frame_array[i].frame.w, frame_array[i].sourceSize.h-frame_array[i].frame.h
			)
			if not frames.has_animation(anim.name):
				frames.add_animation(anim.name)
				frames.set_animation_loop(anim.name, anim.repeat != '1' if anim.has('repeat') else true)
				frames.set_animation_speed(anim.name, 1 / (frame_array[anim.from].duration * 0.001))
			
			frames.add_frame(anim.name, frame)
			
	ResourceSaver.save(frames, path.get_basename() + ".res", ResourceSaver.FLAG_COMPRESS)

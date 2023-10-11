shader_type canvas_item;

uniform vec3 from : source_color;
uniform vec3 to : source_color;
  
void fragment() {
	if(COLOR.rgb == from.rgb)
		COLOR.rgb = to;
}
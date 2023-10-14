shader_type canvas_item;

uniform vec3 red : source_color; //dark
uniform vec3 green : source_color; //normal
uniform vec3 blue : source_color; //light
  
void fragment() {
	COLOR.rgb = red*COLOR.r+green*COLOR.g+blue*COLOR.b;
}
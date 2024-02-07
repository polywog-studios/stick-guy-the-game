shader_type canvas_item;

const vec2 HALF_OFFSET = vec2(0.5, 0.5);

uniform sampler2D mask;
uniform float scale : hint_range(0.0, 1.0, 0.001);

void fragment() {
	float s = scale * 250.0f;
	vec2 offset = HALF_OFFSET * (1.0 - s);
	vec4 mask_color = texture(mask, UV * s + offset);
	COLOR.a = 1.0 - mask_color.a;
}

shader_type canvas_item;

void vertex() {
	VERTEX.y += sin(mod(TIME*2.0,PI*2.0)) * 5.0;
}
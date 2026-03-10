shader_type canvas_item;

uniform bool distort_enabled = false;
uniform float distort_strength = 1.0;
uniform float distort_speed = 10.0;

uniform float border_max = 4.0;
uniform float border_speed = 10.0;

void vertex() {
	if (distort_enabled) {
		float wave = sin((VERTEX.y * 0.05) + TIME * distort_speed);
		VERTEX.x += wave * distort_strength;
	}
}

void fragment() {

	vec4 tex = texture(TEXTURE, UV);

	float border_size = (sin(TIME * border_speed) * 0.5 + 0.5) * border_max;

	vec2 offset = TEXTURE_PIXEL_SIZE * border_size;

	float edge = 0.0;

	edge = max(edge, texture(TEXTURE, UV + vec2(offset.x, 0)).a);
	edge = max(edge, texture(TEXTURE, UV - vec2(offset.x, 0)).a);
	edge = max(edge, texture(TEXTURE, UV + vec2(0, offset.y)).a);
	edge = max(edge, texture(TEXTURE, UV - vec2(0, offset.y)).a);

	if (tex.a < 0.01 && edge > 0.01) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		COLOR = tex;
	}
}
shader_type canvas_item;

uniform float wave_speed = 1.0;
uniform float wave_strength = 0.0035;
uniform float wave_freq = 10.0;

uniform float pixel_size = 150.0;
uniform float jitter_strength = 0.0001;

void fragment() {
	vec2 uv = UV;

	// slight horizontal and vertical wave
	float wave_x = sin((uv.y * wave_freq) + (TIME * wave_speed)) * wave_strength;
	float wave_y = cos((uv.x * (wave_freq * 0.7)) + (TIME * (wave_speed * 0.8))) * (wave_strength * 0.5);

	uv.x += wave_x;
	uv.y += wave_y;

	// tiny pixel-style jitter so it feels less smooth
	vec2 pixel_uv = floor(uv * pixel_size) / pixel_size;
	float jitter = sin((pixel_uv.y * 40.0) + (TIME * 3.0)) * jitter_strength;
	uv.x += jitter;

	COLOR = texture(TEXTURE, uv) * COLOR;
}
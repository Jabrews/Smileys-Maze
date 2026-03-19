shader_type canvas_item;

uniform float pixel_size = 120.0;     // lower = bigger pixels
uniform float speed = 6.0;
uniform float strength = 0.35;

uniform float gray_min = 0.1;
uniform float gray_max = 0.5;

uniform float black_threshold = 0.08;

// hash function (cheap random per pixel)
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
	vec4 base_col = texture(TEXTURE, UV);

	float brightness = (base_col.r + base_col.g + base_col.b) / 3.0;

	if (brightness <= black_threshold) {

		// snap to pixel grid
		vec2 grid = floor(UV * pixel_size);

		// base random per pixel
		float n = hash(grid);

		// animate it (this is the key)
		float t = TIME * speed;
		float animated = hash(grid + vec2(floor(t)));

		// blend static + animated noise
		float noise_val = mix(n, animated, 0.7);

		// map to grayscale
		float gray = mix(gray_min, gray_max, noise_val);

		COLOR = vec4(vec3(gray), base_col.a);
	} else {
		COLOR = base_col;
	}
}
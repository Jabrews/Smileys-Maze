shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int layer_count = 5;
uniform float wave_strength = 0.01;
uniform float wave_speed = 2.0;
uniform float tint_strength = 0.05;
uniform float opacity = 0.15;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 final_color = vec4(0.0);

	for (int i = 0; i < layer_count; i++) {
		float fi = float(i);
		
		// progressive wave offset
		float wave = sin(uv.y * 10.0 + TIME * wave_speed + fi) * wave_strength * (fi + 1.0);
		vec2 offset_uv = uv + vec2(wave, 0.0);

		vec4 col = texture(SCREEN_TEXTURE, offset_uv);

		// slight tint shift per layer
		col.rgb += vec3(
			sin(fi * 1.3) * tint_strength,
			cos(fi * 1.7) * tint_strength,
			sin(fi * 2.1) * tint_strength
		);

		col.a = opacity;

		final_color += col;
	}

	COLOR = final_color;
}

shader_type canvas_item;

uniform sampler2D noise_texture : source_color, repeat_enable;
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec2 noise_uv_scale = vec2(1.0, 1.0);

uniform sampler2D mask_texture : source_color, repeat_disable;
uniform vec2 player_uv = vec2(0.5, 0.5);
uniform vec2 mask_size_uv = vec2(0.18, 0.18);
uniform float mask_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);

	// dissolve
	float noise_value = texture(noise_texture, UV * noise_uv_scale).r;

	// visible when noise is greater than dissolve_amount
	float dissolve_keep = step(dissolve_amount, noise_value);

	// convert current minimap UV into local UV space of the player mask
	vec2 mask_uv = ((UV - player_uv) / mask_size_uv) + vec2(0.5, 0.5);

	float mask_value = 0.0;

	if (
		mask_uv.x >= 0.0 && mask_uv.x <= 1.0 &&
		mask_uv.y >= 0.0 && mask_uv.y <= 1.0
	) {
		mask_value = texture(mask_texture, mask_uv).r;
	}

	//  white area of mask reveals this layer
	float mask_reveal = step(mask_threshold, mask_value);

	float final_alpha = base_color.a * dissolve_keep * mask_reveal;

	COLOR = vec4(base_color.rgb, final_alpha);
}
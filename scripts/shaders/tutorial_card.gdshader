shader_type canvas_item;

uniform float pulse_speed : hint_range(0.0, 5.0) = 1.2;
uniform float pulse_amount : hint_range(0.0, 0.5) = 0.08;

uniform float border_size : hint_range(0.0, 0.1) = 0.03;
uniform float border_strength : hint_range(0.0, 1.0) = 0.18;

uniform float hover_strength : hint_range(0.0, 1.0) = 0.0; // set from code
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
	float glow = pulse * pulse_amount;
	
	float edge = min(min(UV.x, 1.0 - UV.x), min(UV.y, 1.0 - UV.y));
	float border_mask = 1.0 - smoothstep(border_size, border_size + 0.01, edge);
	
	float shimmer = sin(TIME * 2.0 + UV.y * 10.0) * 0.5 + 0.5;
	float border_effect = border_mask * (border_strength + shimmer * 0.05);
	
	vec3 color = tex.rgb;
	color += glow;
	color = mix(color, border_color.rgb, border_effect + hover_strength * 0.12);
	color += hover_strength * 0.08;
	
	COLOR = vec4(color, tex.a);
}
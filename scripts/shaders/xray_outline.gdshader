shader_type spatial;

render_mode unshaded, cull_disabled, depth_test_disabled, depth_draw_never;

uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform vec4 wall_visible_color : source_color = vec4(1.0, 0.1, 0.1, 0.75);
uniform float depth_bias = 0.0005;

void fragment() {
	float scene_depth = texture(depth_texture, SCREEN_UV).r;
	float my_depth = FRAGCOORD.z;

	// if this mesh is visible normally, do not draw it
	if (my_depth <= scene_depth + depth_bias) {
		discard;
	}

	// if this mesh is behind something, show it
	ALBEDO = wall_visible_color.rgb;
	ALPHA = wall_visible_color.a;
}

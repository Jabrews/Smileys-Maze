shader_type canvas_item;

uniform sampler2D noise_texture;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float edge_softness : hint_range(0.0, 0.2) = 0.02;

// 0.0 = starts black, 1.0 = starts grayscale
uniform float starting_visibility : hint_range(0.0, 1.0) = 0.0;
uniform bool stay_complete = true;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 noise_tex = texture(noise_texture, UV);

    // use red channel of noise as reveal value
    float noise_value = noise_tex.r;

    float reveal;
    
    if (stay_complete && progress >= 1.0) {
        reveal = 1.0;
    } else {
        reveal = smoothstep(noise_value - edge_softness, noise_value + edge_softness, progress);
    }

    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 start_color = mix(vec3(0.0), vec3(gray), starting_visibility);

    vec3 final_rgb = mix(start_color, tex.rgb, reveal);

    COLOR = vec4(final_rgb, tex.a * max(reveal, 0.05));
}
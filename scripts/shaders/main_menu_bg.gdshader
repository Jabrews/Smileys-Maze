shader_type canvas_item;

uniform float flicker_speed = 3.0;
uniform float flicker_strength = 0.15;
uniform float noise_strength = 0.05;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // smooth flicker
    float flicker = sin(TIME * flicker_speed) * flicker_strength;

    // subtle randomness
    float noise = rand(UV + TIME) * noise_strength;

    float brightness = 1.0 - flicker - noise;

    tex.rgb *= brightness;

    COLOR = tex;
}
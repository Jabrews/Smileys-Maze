shader_type canvas_item;

uniform float distortion_strength = 0.01;
uniform float wave_speed = 3.0;
uniform float chroma_offset = 0.002;
uniform float glitch_intensity = 0.02;

void fragment() {
    vec2 uv = UV;

    // wave distortion (horizontal wobble)
    float wave = sin(uv.y * 20.0 + TIME * wave_speed) * distortion_strength;
    uv.x += wave;

    // occasional glitch jump
    float glitch = step(0.98, fract(sin(TIME * 10.0) * 1000.0));
    uv.x += glitch * glitch_intensity;

    // chromatic aberration
    float r = texture(TEXTURE, uv + vec2(chroma_offset, 0.0)).r;
    float g = texture(TEXTURE, uv).g;
    float b = texture(TEXTURE, uv - vec2(chroma_offset, 0.0)).b;

    COLOR = vec4(r, g, b, texture(TEXTURE, uv).a);
}
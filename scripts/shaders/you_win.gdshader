shader_type canvas_item;

uniform float move_strength : hint_range(0.0, 20.0) = 5.0;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.02;
uniform float speed : hint_range(0.1, 5.0) = 1.0;

void fragment() {
    vec2 uv = UV;

    float t = TIME * speed;

    // movement (visual offset)
    vec2 offset;
    offset.x = sin(t) * move_strength * 0.002;
    offset.y = cos(t * 1.3) * move_strength * 0.002;

    // distortion (wave)
    uv.x += sin(uv.y * 10.0 + t * 2.0) * distortion_strength;
    uv.y += cos(uv.x * 10.0 + t * 2.0) * distortion_strength;

    uv += offset;

    COLOR = texture(TEXTURE, uv);
}
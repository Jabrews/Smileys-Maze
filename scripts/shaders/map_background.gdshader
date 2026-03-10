shader_type canvas_item;

uniform float pixel_grid = 120.0;
uniform float particle_size = 0.20;
uniform float growth_speed = 0.6;

float rand(vec2 p){
	return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float cluster(vec2 uv, vec2 center, float phase){

	float growth = sin(TIME * growth_speed + phase) * 0.5 + 0.5;
	float radius = particle_size * growth;

	float dist = distance(uv, center);

	float base = step(dist, radius);

	float noise = rand(floor(uv * pixel_grid));

	return base * step(0.55, noise);
}

void fragment() {

	vec2 uv = floor(UV * pixel_grid) / pixel_grid;

	vec2 cluster_grid = floor(uv * 6.0);
	float r = rand(cluster_grid);

	float p = 0.0;

	if (r > 0.82) {

		vec2 center = (cluster_grid + vec2(
			rand(cluster_grid + 1.3),
			rand(cluster_grid + 5.7)
		)) / 6.0;

		// small drifting motion
		center += vec2(
			sin(TIME * 0.5 + r * 10.0),
			cos(TIME * 0.18 + r * 6.0)
		) * 0.05;

		float phase = rand(cluster_grid + 8.2) * 6.28;

		p += cluster(uv, center, phase);
	}

	float alpha = p * 1.0;

	COLOR = vec4(vec3(0.0), alpha);
}
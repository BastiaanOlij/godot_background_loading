shader_type spatial;
render_mode unshaded;

uniform vec4 fade_color : hint_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform sampler2D texture_map : hint_albedo;
uniform vec2 scale = vec2(10.0, 10.0);
uniform float circle_size = 15.0;
uniform float fade_size = 19.0;

varying vec3 coord;

void vertex() {
	coord = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float dist = length(coord);
	float val = clamp((dist - circle_size) / fade_size, 0.0, 1.0);
	
	ALBEDO = mix(texture(texture_map, UV * scale).rgb, fade_color.rgb, val);
}
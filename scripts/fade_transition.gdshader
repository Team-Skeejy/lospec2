shader_type canvas_item;

uniform sampler2D noise;
const int pixelsize = 1;
const vec2 screen_size = vec2(128., 112.);
uniform int pixel_size = 1;
uniform float threshold : hint_range(0.0, 1.0, 0.1);

void fragment() {
	float x = UV.x;
	float y = UV.y;
	x = floor(x * screen_size.x)/screen_size.x;
	y = floor(y * screen_size.y)/screen_size.y;
	float noise_val = texture(noise, vec2(x, y)).r;
	//float t = abs(sin(TIME));
	COLOR = noise_val > threshold ? vec4(0, 0, 0, 1) : vec4(0, 0, 0, 0);
}


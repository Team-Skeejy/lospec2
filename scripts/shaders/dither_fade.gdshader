shader_type canvas_item;

const vec2 screen_size = vec2(256., 224.);
uniform int pixel_size : hint_range(1, 10, 1);
uniform float threshold : hint_range(0.0, 1.0, 0.01);
//const mat2 dither_matrix = mat2(vec2(1,3),vec2(4,2)) / 5.;
const mat4 dither_matrix = mat4(vec4(1, 9, 3, 11),
								vec4(13, 5, 15, 7),
								vec4(4, 12, 2, 10),
								vec4(16, 8, 14, 6)) / 17.;

void fragment() {
	float x = floor(SCREEN_UV.x * screen_size.x/float(pixel_size));
	float y = floor(SCREEN_UV.y * screen_size.y/float(pixel_size));
	x = mod(x, 4.);
	y = mod(y, 4.);
	float mat_val = dither_matrix[int(x)][int(y)];
	COLOR = mat_val >= threshold ? COLOR : vec4(0, 0, 0, 0);
	//COLOR = vec4(x, y, 0, 1);
}

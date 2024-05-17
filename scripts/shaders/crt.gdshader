shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float crt_ghost: hint_range(0.0, 1.0) = 1.0;

uniform bool darken = true;
uniform int num_colors;
uniform float precision: hint_range(0.0, 1.0) = 1.0;

uniform sampler2D palette_in;
uniform sampler2D palette_out;


vec4 swap_color(vec4 color) {
	if (!darken){
		return color;
	}
	float inc = 1.0 / float(num_colors); 
	for (float i = 0.0; i < 1.0; i += inc) {
		vec2 uv = vec2(i, 0.0);
		vec4 color_in = texture(palette_in, uv);
		if (distance(color.rgb, color_in.rgb) <= precision) {
			return texture(palette_out, uv);
		}
	}
	return color;
}


void fragment(){
	vec3 color = swap_color(texture(screen_texture, SCREEN_UV)).rgb/3.;
	color += swap_color(texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0))).rgb/3.;
	color += swap_color(texture(screen_texture, SCREEN_UV - vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0))).rgb/3.;
	
	COLOR = vec4(color, 1.);
}
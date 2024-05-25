shader_type canvas_item;

const vec2 screen_size = vec2(256., 224.);
const int pixel_size = 1;
uniform sampler2D screen_texture: hint_screen_texture;
uniform bool active = true;


void fragment() {
	//float x = floor(UV.x * screen_size.x/float(pixel_size));
	//float y = floor(UV.y * screen_size.y/float(pixel_size));
	//vec2 stepsize = 1./screen_size;
	//float a_1 = texture(screen_texture, SCREEN_UV + vec2(stepsize.x, 0)).a;
	//float a_2 = texture(screen_texture, SCREEN_UV + vec2(-stepsize.x, 0)).a;
	//float a_3 = texture(screen_texture, SCREEN_UV + vec2(0, stepsize.y)).a;
	//float a_4 = texture(screen_texture, SCREEN_UV + vec2(0, -stepsize.y)).a;
	//float alphas[4] = float[](a_1, a_2, a_3, a_4);
	//textures
	//if (a_) {
		//
	//}
	//COLOR = mat_val >= threshold ? vec4(0, 0, 0, 1) : vec4(0, 0, 0, 0);
	////COLOR = vec4(x, y, 0, 1);
}

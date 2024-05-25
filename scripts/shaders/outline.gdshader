shader_type canvas_item;

const vec2 screen_size = vec2(256., 224.);
const int pixel_size = 1;
uniform sampler2D screen_texture: hint_screen_texture;
uniform bool active = false;


void fragment() {
	//float x = floor(UV.x * screen_size.x/float(pixel_size));
	//float y = floor(UV.y * screen_size.y/float(pixel_size));
	//vec2 stepsize = 1./screen_size;
	//float a_1 = texture(screen_texture, SCREEN_UV + vec2(stepsize.x, 0)).a;
	//float a_2 = texture(screen_texture, SCREEN_UV + vec2(-stepsize.x, 0)).a;
	//float a_3 = texture(screen_texture, SCREEN_UV + vec2(0, stepsize.y)).a;
	//float a_4 = texture(screen_texture, SCREEN_UV + vec2(0, -stepsize.y)).a;
	vec2 nearestPixelUV = TEXTURE_PIXEL_SIZE * floor(UV / TEXTURE_PIXEL_SIZE);
	//nearestPixelUV + vec2(0, TEXTURE_PIXEL_SIZE.y);
	float a_1 = texture(TEXTURE, nearestPixelUV + vec2(0, TEXTURE_PIXEL_SIZE.y)).a;
	float a_2 = texture(TEXTURE, nearestPixelUV + vec2(0, -TEXTURE_PIXEL_SIZE.y)).a;
	float a_3 = texture(TEXTURE, nearestPixelUV + vec2(TEXTURE_PIXEL_SIZE.x, 0)).a;
	float a_4 = texture(TEXTURE, nearestPixelUV + vec2(-TEXTURE_PIXEL_SIZE.x, 0)).a;
	float a_5 = texture(TEXTURE, nearestPixelUV + vec2(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)).a;
	float a_6 = texture(TEXTURE, nearestPixelUV + vec2(TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)).a;
	float a_7 = texture(TEXTURE, nearestPixelUV + vec2(-TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)).a;
	float a_8 = texture(TEXTURE, nearestPixelUV + vec2(-TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)).a;
	float tot = a_1 + a_2 + a_3 + a_4 + a_5 + a_6 + a_7 + a_8;
	
	if (active && (tot < 8.0) && (tot > 3.0) ){
		COLOR = vec4(1.,1.,1.,1.) * COLOR.a;
	}
		

}

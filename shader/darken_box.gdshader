shader_type canvas_item;

uniform int lightness;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

const ivec3 RED = ivec3(0xFF, 0x03, 0x2B);
const ivec3 DARK_RED = ivec3(0x80, 0x00, 0x34);
const ivec3 YELLOW = ivec3(0xFF, 0xFF, 0x0D);
const ivec3 ORANGE = ivec3(0xFF, 0x8F, 0x00);
const ivec3 GREEN = ivec3(0x0A, 0xFF, 0x0A);
const ivec3 DARK_GREEN = ivec3(0x00, 0x70, 0x62);
const ivec3 CYAN = ivec3(0x0D, 0xFF, 0xFF);
const ivec3 BLUE = ivec3(0x3C, 0x80, 0xDB);
const ivec3 DARK_BLUE = ivec3(0x29, 0x29, 0xFF);
const ivec3 INDIGO = ivec3(0x2D, 0x00, 0x6E);
const ivec3 PINK = ivec3(0xFF, 0x08, 0xFF);
const ivec3 PURPLE = ivec3(0x6E, 0x00, 0x85);
const ivec3 DARK_PURPLE = ivec3(0x26, 0x0A, 0x34);
const ivec3 BLACK = ivec3(0x00, 0x00, 0x00);
const ivec3 GREY = ivec3(0x7D, 0x7D, 0xA3);
const ivec3 WHITE = ivec3(0xFF, 0xFF, 0xFF);

ivec3 darken(ivec3 colour) {
	if(colour == RED) return DARK_RED;
	if(colour == DARK_RED) return DARK_PURPLE;
	if(colour == YELLOW) return ORANGE;
	if(colour == ORANGE) return DARK_RED;
	if(colour == GREEN) return DARK_GREEN;
	if(colour == DARK_GREEN) return INDIGO;
	if(colour == CYAN) return BLUE;
	if(colour == BLUE) return DARK_PURPLE;
	if(colour == DARK_BLUE) return PURPLE;
	if(colour == INDIGO) return DARK_PURPLE;
	if(colour == PINK) return PURPLE;
	if(colour == PURPLE) return DARK_PURPLE;
	if(colour == DARK_PURPLE) return BLACK;
	if(colour == BLACK) return BLACK;
	if(colour == GREY) return DARK_PURPLE;
	if(colour == WHITE) return PINK;
	return ivec3(0x43, 0x45, 0x1A);
}

ivec3 lighten(ivec3 colour) {
	if(colour == RED) return PINK;
	if(colour == DARK_RED) return RED;
	if(colour == YELLOW) return WHITE;
	if(colour == ORANGE) return YELLOW;
	if(colour == GREEN) return WHITE;
	if(colour == DARK_GREEN) return GREEN;
	if(colour == CYAN) return WHITE;
	if(colour == BLUE) return CYAN;
	if(colour == DARK_BLUE) return CYAN;
	if(colour == INDIGO) return PURPLE;
	if(colour == PINK) return WHITE;
	if(colour == PURPLE) return PINK;
	if(colour == DARK_PURPLE) return PURPLE;
	if(colour == BLACK) return DARK_PURPLE;
	if(colour == GREY) return CYAN;
	if(colour == WHITE) return WHITE;
	return ivec3(0x43, 0x45, 0x1A);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {	
	bool isDark = lightness < 0;
	int target = abs(lightness);
	vec4 source = texture(screen_texture, SCREEN_UV);
	ivec3 colour = ivec3(int(source.r * 255.), int(source.g * 255.), int(source.b * 255.));
	for(int i = 0; i < target; i++) {
		colour = isDark ? darken(colour) : lighten(colour);
	}
	COLOR = vec4(float(colour.r)/255.,float(colour.g)/255.,float(colour.b)/255., source.a);
}
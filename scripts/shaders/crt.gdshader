shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float crt_ghost: hint_range(0.0, 1.0) = 1.0;
uniform float v_pixels = 223.;
void fragment(){
	vec3 color = texture(screen_texture, SCREEN_UV).rgb/3.;
	color += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb/3.;
	color += texture(screen_texture, SCREEN_UV - vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb/3.;
	
	//float scanline_y = mod(SCREEN_UV.y, 1./v_pixels)*v_pixels;
	//scanline_y = sin(scanline_y*PI);
	//color *= smoothstep(0.0, 0.8, scanline_y);
	//COLOR = vec4(scanline_y, 0., 0., 1.);
	
	COLOR = vec4(color, 1.);
}
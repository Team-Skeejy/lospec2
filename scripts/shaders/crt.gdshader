shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float crt_ghost: hint_range(0.0, 1.0) = 1.0;

void fragment(){
	vec3 color = texture(screen_texture, SCREEN_UV).rgb/3.;
	color += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb/3.;
	color += texture(screen_texture, SCREEN_UV - vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb/3.;
	COLOR = vec4(color, 1.);
}
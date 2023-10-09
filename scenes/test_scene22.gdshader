shader_type spatial;

uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D CROSS_HATCH;
uniform float CROSS_HATCH_SCALE = 1.0;

void fragment() {
	vec4 crosshatch = texture(CROSS_HATCH, SCREEN_UV * CROSS_HATCH_SCALE);
	vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	float luminance = screenColor.r;
	luminance += screenColor.g;
	luminance += screenColor.b;
	
	float ch = 0.0;
	
	if(luminance < 0.1) {
		ch += crosshatch.r + crosshatch.g + crosshatch.b;
	}
	else if (luminance < 0.05) {
		ch += crosshatch.r + crosshatch.g;
	}
	else if (luminance < 0.1) {
		ch += crosshatch.r;
	}
	vec4 normal_color = texture(NORMAL_TEXTURE, SCREEN_UV) * ch * 10.0;
	ALBEDO = normal_color.rgb;
}

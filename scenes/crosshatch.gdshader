shader_type spatial;
render_mode blend_mix;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture, filter_linear_mipmap;
uniform sampler2D CROSS_HATCH_R;
uniform sampler2D CROSS_HATCH_G;
uniform sampler2D CROSS_HATCH_B;
uniform float CROSS_HATCH_SCALE = 1.0;
uniform float CROSS_HATCH_STRENGTH = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float DEPTH_DEADZONE = 1.0;
uniform vec4 albedo : source_color;
uniform float LOWER = 0.2;
uniform float MID = 0.5;
uniform float UPPER = 0.75;

void fragment() {
	float luminance = 0.0;
	luminance += texture(SCREEN_TEXTURE, SCREEN_UV).r;
	luminance += texture(SCREEN_TEXTURE, SCREEN_UV).g;
	luminance += texture(SCREEN_TEXTURE, SCREEN_UV).b;
	
	float r_lum = 1.0 - texture(CROSS_HATCH_R, UV * CROSS_HATCH_SCALE).r * CROSS_HATCH_STRENGTH;
	float g_lum = 1.0 - texture(CROSS_HATCH_G, UV * CROSS_HATCH_SCALE).g * CROSS_HATCH_STRENGTH;
	float b_lum = 1.0 - texture(CROSS_HATCH_B, UV * CROSS_HATCH_SCALE).b * CROSS_HATCH_STRENGTH;
	
	float depth = texture(DEPTH_TEXTURE, UV).r;
	depth += texture(DEPTH_TEXTURE, UV).g;
	depth += texture(DEPTH_TEXTURE, UV).b;
	
	if(depth < DEPTH_DEADZONE) {
		if(luminance < LOWER) {
		NORMAL *= r_lum;
		NORMAL *= g_lum;
		NORMAL *= b_lum;
		}
		else if(luminance < MID) {
			NORMAL *= r_lum;
			NORMAL *= g_lum;
			//NORMAL *= texture(CROSS_HATCH, SCREEN_UV * CROSS_HATCH_SCALE).g;
		}
		else if(luminance < UPPER) {
			NORMAL *= r_lum;
		}
	}
	//ALBEDO.rgb = vec3(1.0,1.0,1.0);
	ALBEDO = albedo.rgb;
}

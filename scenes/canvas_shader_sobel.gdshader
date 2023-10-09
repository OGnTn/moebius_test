shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture;

uniform float noise_strength = 1.0;

uniform sampler2D NOISE_PATTERN;
uniform sampler2D CROSS_HATCH_R;
uniform sampler2D CROSS_HATCH_G;
uniform sampler2D CROSS_HATCH_B;
uniform float CROSS_HATCH_SCALE = 1.0;
uniform float CROSS_HATCH_STRENGTH = 1.0;

uniform float LOWER = 0.2;
uniform float MID = 0.5;
uniform float UPPER = 0.75;

uniform float DEPTH_DEADZONE = 1.0;


const mat3 sobel_h = mat3(vec3(-1, 0, 1), vec3(-2, 0, 2), vec3(-1, 0, 1));
const mat3 sobel_v = mat3(vec3(1, 2, 1), vec3(0, 0, 0), vec3(-1, -2, -1));

void fragment() {
    vec4 screenColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 noise_tex = texture(NOISE_PATTERN, SCREEN_UV);
	//vec4 crosshatch = texture(CROSS_HATCH, SCREEN_UV * CROSS_HATCH_SCALE);
	float noiseValue = 0.0;
	noiseValue += noise_tex.r;
	noiseValue += noise_tex.g;
	noiseValue += noise_tex.b;
	noiseValue *= noise_strength;

	

	float luminance = 0.0;
	luminance += texture(SCREEN_TEXTURE, SCREEN_UV).r;
	luminance += texture(SCREEN_TEXTURE, SCREEN_UV).g;
	luminance += texture(SCREEN_TEXTURE, SCREEN_UV).b;
	
	float r_lum = 1.0 - texture(CROSS_HATCH_R, UV * CROSS_HATCH_SCALE).r * CROSS_HATCH_STRENGTH;
	float g_lum = 1.0 - texture(CROSS_HATCH_G, UV * CROSS_HATCH_SCALE).g * CROSS_HATCH_STRENGTH;
	float b_lum = 1.0 - texture(CROSS_HATCH_B, UV * CROSS_HATCH_SCALE).b * CROSS_HATCH_STRENGTH;
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	depth += texture(DEPTH_TEXTURE, SCREEN_UV).g;
	depth += texture(DEPTH_TEXTURE, SCREEN_UV).b;
	
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
	
	
	
    float color_h = 0.0;
	float color_v = 0.0;
	for(int i = 0; i < 3; i++) {
		for(int j = 0; j < 3; j++) {
			float cur_x = SCREEN_UV.x  + (float(i) - 1.0 + noiseValue) / VIEWPORT_SIZE.x;
			float cur_y = SCREEN_UV.y + (float(j) - 1.0 + noiseValue) / VIEWPORT_SIZE.y;
			vec4 cur_color_h = texture(NORMAL_TEXTURE, vec2(cur_x, cur_y)) * sobel_h[i][j];
			vec4 cur_color_v = texture(NORMAL_TEXTURE, vec2(cur_x, cur_y)) * sobel_v[i][j];
			color_h += cur_color_h.r;
			color_h += cur_color_h.g;
			color_h += cur_color_h.b;
			color_v += cur_color_v.r;
			color_v += cur_color_v.g;
			color_v += cur_color_v.b;
		}
	}
	
	float max_color = max(color_h, color_v);
	//max_color = 1.0 - max_color;
	
	
	
    //ALBEDO.r = max_color;
	//ALBEDO.g = max_color;
	//ALBEDO.b = max_color;
    //ALPHA = normal_color.a;
	//vec3 og_color = ALBEDO;
	
	//vec3 inverted_color = vec3(1.0) - og_color;
	float inverted_color_mag = max_color;
	//inverted_color_mag += inverted_color.r;
	//inverted_color_mag += inverted_color.g;
	//inverted_color_mag += inverted_color.b;
	
	
	inverted_color_mag = 1.0 - inverted_color_mag;
	
	ALBEDO = vec3(inverted_color_mag,inverted_color_mag,inverted_color_mag) * texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
}

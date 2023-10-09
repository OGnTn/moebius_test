shader_type spatial;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture;
uniform sampler2D CROSSHATCH_TEXTURE;
uniform float CROSSHATCH_SCALE = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	
	
	
	float luminance = 0.0;
	luminance += COLOR.r;
	luminance += COLOR.g;
	luminance += COLOR.b;
	
	if(luminance < 2.9) {
		float crosshatch = 0.0;
		crosshatch += texture(CROSSHATCH_TEXTURE, UV * CROSSHATCH_SCALE).r;
		//crosshatch += texture(CROSSHATCH_TEXTURE, UV * CROSSHATCH_SCALE).g;
		//crosshatch += texture(CROSSHATCH_TEXTURE, UV * CROSSHATCH_SCALE).b;
		NORMAL *= crosshatch;
	}
}

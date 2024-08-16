shader_type spatial;
render_mode blend_mix,depth_draw_always,cull_back,diffuse_burley,specular_schlick_ggx;
render_mode unshaded;

uniform mediump vec4 default_color : source_color = vec4(0.1, 0.1, 0.8, 1.0);
uniform mediump vec4 glow_color : source_color = vec4(0.9, 9.9, 0.9,1.0);
uniform float brightness : hint_range(1,10);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = default_color.rgb*glow_color.rgb;
	ALPHA = default_color.a*brightness;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

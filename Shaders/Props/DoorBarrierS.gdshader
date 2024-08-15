shader_type spatial;
render_mode cull_disabled, blend_mix, depth_prepass_alpha, specular_disabled, vertex_lighting;

uniform sampler2D albedo_texture: filter_nearest, source_color;
uniform vec4 albedo_color: source_color = vec4(0.0,0.0,0.0,1.0);

void vertex() {
	// Called for every vertex the material is visible on.
	float wiggleTime = (TIME * 5.0f) + (VERTEX.x + VERTEX.y)*10.0f;
	VERTEX.x += sin(wiggleTime) * 0.0125f;
	VERTEX.y += cos(wiggleTime) * 0.0125f;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	float wiggleTime = (TIME * 5.0f);
	uv.x += sin(wiggleTime)*0.0125f;
	uv.y += sin(wiggleTime)*0.0125f;
	vec4 texture_ref = texture(albedo_texture,uv);
	ALBEDO = texture_ref.rgb*albedo_color.rgb;
	ALPHA = albedo_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

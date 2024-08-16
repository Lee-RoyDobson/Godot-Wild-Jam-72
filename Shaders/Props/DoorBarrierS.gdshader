shader_type spatial;
render_mode cull_disabled, blend_mix, depth_prepass_alpha, specular_disabled, vertex_lighting;

uniform sampler2D albedo_texture: filter_nearest, source_color;
uniform vec4 albedo_color: source_color = vec4(0.0,0.0,0.0,1.0);
uniform vec4 phase_color: source_color = vec4(0.0,0.0,0.0,1.0);
uniform float glow_intesity:hint_range(1.0, 5.0) = 1.0f;

void vertex() {
	// Called for every vertex the material is visible on.
	float wiggleTime = (TIME * 5.0f) + (VERTEX.x + VERTEX.y)*10.0f;
	float crazy_s = cos(sin(VERTEX.x*0.2f + TIME*25.0f)+VERTEX.y);
	VERTEX.x += (sin(wiggleTime) * 0.0125f)+crazy_s*0.02f;
	VERTEX.y += cos(wiggleTime) * 0.0125f;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	float wiggleTime = (TIME * 5.0f);
	uv.x += sin(wiggleTime)*0.0125f;
	uv.y += sin(wiggleTime)*0.0125f;
	vec4 texture_ref = texture(albedo_texture,uv);
	
	float glow = sin((TIME*PI)/10.0f);
	vec3 app_color = mix(albedo_color.rgb, phase_color.rgb, glow);
	ALBEDO = texture_ref.rgb*app_color;
	
	float flare = (sin((TIME*PI)*0.5f)/2.0f)*0.125f + 1.0f;
	ALPHA = albedo_color.a * flare*glow_intesity;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

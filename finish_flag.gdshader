shader_type spatial;

// Uniforms can be changed in the Material properties to tweak the glow
uniform vec4 glow_color : hint_color = vec4(1.0, 0.5, 0.5, 1.0);
uniform float intensity = 1.0;

void fragment() {
	// Simple glow based on the distance from the fragment to the camera
	float dist = distance(VERTEX, CAMERA_MATRIX[3].xyz);
	float glow = 1.0 / dist * intensity;
	ALBEDO = vec3(glow_color);
	EMISSION = vec3(glow_color) * glow;
}

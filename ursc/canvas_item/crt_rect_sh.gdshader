shader_type canvas_item;

uniform bool hide = false;
uniform vec4 color : source_color = vec4(1);
uniform sampler2D screen_t : hint_screen_texture;
uniform float strength = 0.2;

void fragment(){
	vec4 pixel = texture(screen_t, SCREEN_UV);
        COLOR = pixel;
	if (hide == false){ 
		
		vec3 grayscale_value = vec3(dot(pixel.rgb, vec3(0.299, 0.587, 0.114)));
		float range = 1.0 - step(distance(pixel.rgb, color.rgb), strength);
		COLOR.rgb = mix(pixel.rgb, grayscale_value, range);
	}
	
}
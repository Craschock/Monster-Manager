shader_type spatial;

render_mode unshaded, cull_front;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 1.0) = 0.02;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += NORMAL * outline_width;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = outline_color.rgb;
	EMISSION = outline_color.rgb * 2.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

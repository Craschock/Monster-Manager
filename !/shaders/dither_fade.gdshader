shader_type spatial;
render_mode depth_draw_opaque, cull_back;

// Basic material properties
uniform sampler2D albedo_texture : source_color;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.5;

instance uniform float fade_amount : hint_range(0.0, 1.0) = 0.0;

const float DITHER_THRESHOLDS[16] = float[16](
	1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
	13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
	4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
	16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
);

void fragment() {
	vec4 tex_color = texture(albedo_texture, UV);

	ALBEDO = tex_color.rgb * albedo_color.rgb;
	ROUGHNESS = roughness;

	ivec2 pixel_pos = ivec2(FRAGCOORD.xy);

	int index = (pixel_pos.x % 4) + (pixel_pos.y % 4) * 4;

	if (fade_amount < DITHER_THRESHOLDS[index]) {
		discard;
	}
}
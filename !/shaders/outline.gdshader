shader_type spatial;

render_mode unshaded, cull_front, depth_draw_always;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 0.5) = 0.04;

void vertex() {
    VERTEX += NORMAL * outline_width;
}

void fragment() {
    ALBEDO = outline_color.rgb;
    EMISSION = outline_color.rgb * 2.0;
}
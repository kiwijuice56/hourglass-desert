shader_type canvas_item;

uniform sampler2D img: hint_default_black;

void fragment() {
	COLOR *= texture(img, UV + 0.5 * vec2(UV.y - 0.5, UV.x - 0.5) * sin(TIME * 0.1) * sin(TIME * 0.2 + 13.0));
	COLOR.r *= 1.0 + sin(TIME * 0.2) * 0.1;
}

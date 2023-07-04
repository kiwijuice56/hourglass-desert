shader_type canvas_item;

uniform sampler2D img: hint_default_black;
uniform sampler2D bg: hint_default_black, repeat_enable;

void fragment() {
	if (COLOR.r < 0.001) {
		COLOR = texture(bg, vec2(1.0, 244.0/366.0) * SCREEN_UV + vec2(0.01, 0.012) * TIME);
	} else {
		COLOR = texture(img, UV + 0.5 * vec2(UV.y - 0.5, UV.x - 0.5) * sin(TIME * 0.1) * sin(TIME * 0.2 + 13.0));
	}
	COLOR.r *= 1.0 + sin(TIME * 0.2) * 0.2;
}

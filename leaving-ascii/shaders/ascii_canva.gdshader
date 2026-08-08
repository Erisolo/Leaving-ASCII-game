shader_type canvas_item;

uniform sampler2D _screen : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D _ascii_tex : repeat_disable, filter_nearest;

uniform float _char_size = 8.0;
uniform float _char_count = 10.0;

float get_luminosity(vec3 color)
{
	return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

void fragment()
{
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;

	// Find the current 8x8 character cell.
	vec2 cell = floor(FRAGCOORD.xy / _char_size);

	// Sample the screen at the center of that cell.
	vec2 screen_uv =
		(cell * _char_size + vec2(_char_size * 0.5))
		/ screen_size;

	vec3 tex = texture(_screen, screen_uv).rgb;

	// Brightness -> character index.
	float luminosity = get_luminosity(tex);

	float char_index = floor(
		luminosity * _char_count
	);

	char_index = clamp(
		char_index,
		0.0,
		_char_count - 1.0
	);

	// Pixel inside the current 8x8 character.
	vec2 pixel = mod(FRAGCOORD.xy, _char_size);

	// Sample the 80x8 atlas.
	// +0.5 samples the center of each source pixel.
	vec2 ascii_uv = vec2(
		(char_index * _char_size + pixel.x + 0.5)
			/ (_char_count * _char_size),

		(pixel.y + 0.5) / _char_size
	);

	// Your texture is BLACK background + WHITE characters.
	float glyph = texture(_ascii_tex, ascii_uv).r;

	// Threshold the glyph.
	glyph = step(0.5, glyph);

	COLOR = vec4(tex * glyph, 1.0);
}
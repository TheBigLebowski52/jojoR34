shader_type canvas_item;

//non sto capendo un cazzo
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_strength : hint_range(0.0, 5.0) = 2.5;

void fragment() {
    vec2 size = 1.0 / SCREEN_PIXEL_SIZE;
    vec4 sum = vec4(0.0);
    float count = 0.0;

    // blur semplice 5x5
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_strength;
            sum += texture(SCREEN_TEXTURE, SCREEN_UV + offset / size);
            count += 1.0;
        }
    }

    COLOR = sum / count;
}

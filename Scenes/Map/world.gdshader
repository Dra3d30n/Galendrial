shader_type canvas_item;

// -------------------------------
// User-adjustable uniforms
// -------------------------------
uniform float grey_intensity = .05;         // overall grayscale noise strength
uniform float block_size = 1.0;        // size of noise blocks
uniform float gray_freq = 32.0;        // frequency multiplier for grayscale noise
uniform vec2 gray_offset = vec2(100.0, 0.0); // offset for grayscale hash

uniform vec3 rgb_freq = vec3(32.0, 32.0, 32.0);       // frequency multipliers for RGB tint
uniform vec3 rgb_offset = vec3(100.0, 200.0, 300.0); // offset for RGB hash
uniform vec3 rgb_intensity = vec3(0.1, 0.1, 0.1);    // strength of RGB tint
uniform float rgb_div = 100.0;                         // division factor for subtle RGB

// -------------------------------
// Hash function - returns -1..1
// -------------------------------
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453) * 2.0 - 1.0;
}

void fragment() {
    vec4 orig = texture(TEXTURE, UV);
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 pixel_pos = floor(UV * tex_size / block_size);

    // -------------------------------
    // Grayscale noise
    // -------------------------------
    float gray_noise = hash(pixel_pos * gray_freq + gray_offset) * grey_intensity;

    // -------------------------------
    // Optional tiny RGB tint
    // -------------------------------
    vec3 tiny_rgb = vec3(
        hash(pixel_pos * rgb_freq.x + vec2(rgb_offset.x)) * rgb_intensity.x,
        hash(pixel_pos * rgb_freq.y + vec2(rgb_offset.y)) * rgb_intensity.y,
        hash(pixel_pos * rgb_freq.z + vec2(rgb_offset.z)) * rgb_intensity.z
    );

    // Combine grayscale and RGB tint
    vec3 final_noise = vec3(gray_noise) + tiny_rgb / rgb_div;

    COLOR = orig+ vec4(final_noise, 0.0);
}

shader_type spatial;

void fragment() {
    // Create a moving pattern based on UV coordinates and time
    float pattern = sin((UV.y + TIME * 5.0) * 5.0) * 2.5 + 1.5;

    // Create a smoothly changing color based on time and UV coordinates
    vec3 baseColor = vec3(0.0, 0.0, 0.5);
    vec3 dynamicColor = vec3(
        0.5 + 0.5 * sin(TIME * 2.0),
        0.5 + 0.5 * cos(TIME * 2.0),
        0.5 + 0.5 * sin(TIME + UV.x)
    );

    // Combine the base color with the dynamic color and apply the pattern
    vec3 color = (baseColor + dynamicColor) * pattern;

    // Output the final color
    ALBEDO = color;

    // Set emission for glowing effect
    vec3 emission_color = vec3(0.0, 0.0, 0.2);
    EMISSION = emission_color * 0.1; // Adjust the emission intensity as needed
}

render_mode cull_disabled;


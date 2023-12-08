shader_type spatial;

void vertex() {
    // Transform the vertex position with wavy effect
    VERTEX.x += sin(TIME * 10.0 + VERTEX.y * 10.0) * 2.5; 
}

void fragment() {
    // Set the initial color to black
    vec3 base_color = vec3(0.0, 0.0, 1.0);
    vec3 emission_color = vec3(0.0, 0.1, 1.0); // Adjust the emission color as needed
    float emission_strength = 2.0; // Adjust the emission strength as needed

    ALPHA = 0.5;

    // Add emission to the base color
    vec3 final_color = base_color + emission_color * emission_strength;

    ALBEDO = final_color;

    // Set emission for glowing effect
    EMISSION = emission_color * emission_strength;
}

render_mode cull_disabled;

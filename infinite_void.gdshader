shader_type spatial;


void vertex() {
    // Transform the vertex position with wavy effect
    VERTEX.x += sin(TIME * 20.0 + VERTEX.y * 20.0) * 0.055;
	VERTEX.y += cos(TIME * 20.0 + VERTEX.x * 20.0) * 0.055;
}

void fragment() {
    // Set the initial color to black
    ALBEDO = vec3(0.0, 0.0, 0.0);

    // Create a pulsating color shift
    vec3 baseColor = vec3(0.1, 0.2, 0.5);
    vec3 colorShift = vec3(0.8, 0.1, 0.3);
    vec3 finalColor = baseColor + sin(TIME / 2.0) * colorShift;

    // Create a mask for the thin blue lines
    float lineMask = step(0.10, abs(fract(VERTEX.x / 5.5) - 0.1));
	
    // Mix the line color with the final color based on the mask
    ALBEDO = mix(finalColor, vec3(0.0, 0.0, 0.0), lineMask);
}

render_mode cull_disabled;



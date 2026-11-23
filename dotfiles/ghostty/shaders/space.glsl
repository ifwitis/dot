// Stars in space, adapted from omerxx's dotfiles

#define LAYERS        16
#define DENSITY       20.0
#define STAR_SIZE     0.06
#define BRIGHTNESS    0.6
#define STAR_COLOR    vec3(0.9, 0.93, 1.0)
#define BLEND_THRESH  0.5

#define FLY_SPEED     0.04   // how fast you're moving forward
#define FOCAL_LENGTH  4.0
#define NEAR_FADE     1.5
#define FAR_FADE      13.0

float hash(vec2 p) {
    p = fract(p * vec2(127.1, 311.7));
    p += dot(p, p + 19.19);
    return fract(p.x * p.y);
}

float starCell(vec2 cellID, vec2 cellUV, float layer, float depth, float t, float pixelWidth) {
    vec2 seed = cellID + vec2(layer * 17.3, layer * 5.7);
    vec2 pos = vec2(0.2 + hash(seed) * 0.6, 0.2 + hash(seed + 0.5) * 0.6);

    float dist = length(cellUV - pos);
    float size = STAR_SIZE * (0.4 + hash(seed + 2.0) * 0.6) / sqrt(max(depth, 0.5) / 4.0);

    float twinkleSpeed = 0.3 + hash(seed + 5.0) * 0.5;
    float twinklePhase = hash(seed + 6.0) * 6.28318;
    float twinkle = 0.75 + 0.25 * sin(t * twinkleSpeed + twinklePhase);

    float alpha = (0.5 + hash(seed + 3.0) * 0.5) * BRIGHTNESS * twinkle;

    return alpha * (1.0 - smoothstep(max(0.0, size - pixelWidth), size + pixelWidth, dist));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float aspect = iResolution.x / iResolution.y;

    // center the UV so origin is middle of screen
    vec2 centeredUV = (uv - 0.5) * vec2(aspect, 1.0);

    float t = iTime;
    float brightness = 0.0;

    float travel = t * FLY_SPEED;
    float wholeTravel = floor(travel);
    float partialTravel = fract(travel);

    for (int i = 0; i < LAYERS; i++) {
        float fi = float(i);

        // each layer represents a fixed plane in 3D space — continuous parallax
        float layer = wholeTravel + fi;
        float depth = 1.0 + fi - partialTravel;

        // expand UV outward from center as stars approach
        vec2 zoomedUV = centeredUV * depth / FOCAL_LENGTH;

        float scale = DENSITY;
        vec2 gridUV = zoomedUV * scale;
        vec2 cellID = floor(gridUV);
        vec2 cellUV = fract(gridUV);

        // smooth out stars smaller than a pixel
        float pixelWidth = scale * depth / (FOCAL_LENGTH * iResolution.y);

        // fade stars in and out as they approach and pass the camera
        float nearFade = smoothstep(0.2, NEAR_FADE, depth);
        float farFade = 1.0 - smoothstep(FAR_FADE, float(LAYERS), depth);

        // fade out stars as they fly past the edges
        float edgeFade = 1.0 - smoothstep(0.3, 0.8, length(centeredUV));

        brightness += starCell(cellID, cellUV, layer, depth, t, pixelWidth) * nearFade * farFade * edgeFade;
    }

    vec4 term = texture(iChannel0, uv);
    float luma = dot(term.rgb, vec3(0.299, 0.587, 0.114));
    float blend = smoothstep(BLEND_THRESH * 0.4, BLEND_THRESH, 1.0 - luma);
    vec3 col = term.rgb + STAR_COLOR * brightness * blend;

    fragColor = vec4(col, term.a);
}

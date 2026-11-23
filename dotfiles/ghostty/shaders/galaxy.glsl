// Deep space galaxy, created with ChatGPT

#define STAR_BRIGHTNESS 1.4
#define STAR_DENSITY 0.85
#define FORWARD_SPEED 0.04
#define STAR_SIZE 1.5

#define CLUSTER_BRIGHTNESS 1.35
#define CLUSTER_INTERVAL 24.0
#define CLUSTER_RADIUS 0.135
#define CLUSTER_IRREGULARITY 0.35

#define NEBULA_STRENGTH 0.48

#define BLACK_HOLE_STRENGTH 1.4
#define BLACK_HOLE_INTERVAL 100.0
#define BLACK_HOLE_MIN_SIZE 0.6
#define BLACK_HOLE_MAX_SIZE 13.4

#define BACKGROUND_MIX 0.96
#define FLIP_ART_Y 1

#define PI 3.14159265359

float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

vec2 hash22(vec2 p) {
    return vec2(hash21(p + 13.17), hash21(p + 71.93));
}

float noise2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(hash21(i), hash21(i + vec2(1.0, 0.0)), f.x),
        mix(hash21(i + vec2(0.0, 1.0)), hash21(i + vec2(1.0, 1.0)), f.x),
        f.y
    );
}

float cloud(vec2 p) {
    return 0.57 * noise2(p)
         + 0.28 * noise2(p * 2.07 + 13.1)
         + 0.15 * noise2(p * 4.21 - 7.8);
}

// Pixel-sized stars with soft glow
float starShape(vec2 q, float size, float flare) {
    float d2 = dot(q, q);
    float s2 = size * size;

    float core = 1.0 - smoothstep(s2 * 0.1225, s2, d2);
    float halo = 0.22 * exp(-d2 / (s2 * 6.0));
    float cross = 0.0;

    if (flare > 0.92) {
        cross = 0.35 * (
            exp(-abs(q.x) / max(size * 0.4, 0.1))
            * exp(-abs(q.y) / (size * 5.0))
          + exp(-abs(q.y) / max(size * 0.4, 0.1))
            * exp(-abs(q.x) / (size * 5.0))
        );
    }

    return core + halo + cross;
}

// Stars approach the camera through perspective
vec3 forwardStars(vec2 p, float t, float height) {
    vec3 result = vec3(0.0);

    for (int layer = 0; layer < 5; layer++) {
        float id = float(layer);
        float seed = id * 17.31;
        float z = fract(0.15 + id / 5.0 - t * FORWARD_SPEED * 0.25);
        z = max(z, 0.025);

        float fade = smoothstep(0.06, 0.20, z)
                   * (1.0 - smoothstep(0.82, 0.98, z));

        if (fade < 0.001) continue;

        float scale = 32.0;
        vec2 shift = vec2(seed, seed * 0.73);
        vec2 grid = p * z * scale + shift;
        vec2 cell = floor(grid);

        // Check nearby cells for visible stars
        if (hash21(cell + seed) > 0.28 * STAR_DENSITY)
            continue;

        vec2 offset = mix(
            vec2(0.15), vec2(0.85),
            hash22(cell + seed * 3.1)
        );

        // Screen-space distance in pixels
        vec2 q = (fract(grid) - offset) * height / (scale * z);
        float size = STAR_SIZE * mix(0.65, 2.5, 1.0 - z);

        if (dot(q, q) > size * size * 81.0)
            continue;

        float gold = step(0.73, hash21(cell + seed * 5.9));
        float flare = hash21(cell + seed * 11.9);
        float phase = hash21(cell + seed * 3.17) * 2.0 * PI;
        float twinkle = 0.7 + 0.3 * sin(t * 1.6 + phase);

        vec3 color = mix(
            vec3(0.78, 0.87, 1.0),
            vec3(1.0, 0.72, 0.32),
            gold
        );

        float brightness = mix(0.35, 1.3, 1.0 - z);

        result += color * starShape(q, size, flare)
                * brightness * twinkle * fade;
    }

    return result * STAR_BRIGHTNESS;
}

// Dense, distant twinkling stars
vec3 distantStars(vec2 p, float t, float height) {
    vec2 grid = p * 95.0 + 21.3;
    vec2 cell = floor(grid);
    vec2 f = fract(grid);

    if (hash21(cell + 14.7) > 0.16 * STAR_DENSITY)
        return vec3(0.0);

    vec2 offset = mix(vec2(0.15), vec2(0.85), hash22(cell + 8.1));
    vec2 q = (f - offset) * height / 95.0;

    if (dot(q, q) > 100.0)
        return vec3(0.0);

    float phase = hash21(cell + 5.3) * 2.0 * PI;
    float twinkle = 0.35 + 0.65 * (0.5 + 0.5 * sin(t * 1.3 + phase));
    float gold = step(0.78, hash21(cell + 19.1));

    vec3 color = mix(
        vec3(0.70, 0.82, 1.0),
        vec3(1.0, 0.75, 0.38),
        gold
    );

    float flare = hash21(cell + 31.7);

    return color * starShape(q, 1.15, flare)
         * twinkle * 0.65 * STAR_BRIGHTNESS;
}

// Bright clusters emerge occasionally
vec3 stellarClusters(vec2 p, float t, float height) {
    float id = floor(t / CLUSTER_INTERVAL);
    float age = fract(t / CLUSTER_INTERVAL);

    float fade = smoothstep(0.02, 0.22, age)
               * (1.0 - smoothstep(0.53, 0.95, age));

    if (fade < 0.001)
        return vec3(0.0);

    vec2 center = vec2(
        mix(-0.65, 0.65, hash21(vec2(id, 2.4))),
        mix(-0.32, 0.32, hash21(vec2(id, 7.9)))
    );

    center += vec2(age * 0.008, 0.0);

    vec2 d = p - center;
    float d2 = dot(d, d);

    if (d2 > CLUSTER_RADIUS * CLUSTER_RADIUS * 2.56)
        return vec3(0.0);

    float angle = atan(d.y, d.x);
    float distance = sqrt(d2);

    // Irregular cloud boundary
    float shape = 0.65 * sin(angle * 3.0 + id * 2.7)
                + 0.25 * sin(angle * 5.0 - id * 1.9)
                + 0.10 * sin(angle * 9.0 + id * 4.3);

    float radius = CLUSTER_RADIUS * (
        1.0 + CLUSTER_IRREGULARITY * shape
    );

    float envelope = 1.0 - smoothstep(
        radius * 0.55, radius * 1.15, distance
    );

    if (envelope <= 0.001)
        return vec3(0.0);

    vec3 result = vec3(0.0);
    vec2 grid = (p + vec2(id * 3.71, id * 5.19)) * 105.0;
    vec2 cell = floor(grid);
    vec2 f = fract(grid);

    if (hash21(cell + id * 5.1) < 0.45) {
        vec2 offset = mix(
            vec2(0.15), vec2(0.85),
            hash22(cell + id * 2.3)
        );

        vec2 q = (f - offset) * height / 105.0;

        if (dot(q, q) < 100.0) {
            float gold = step(0.65, hash21(cell + 19.8));

            vec3 color = mix(
                vec3(0.78, 0.88, 1.0),
                vec3(1.0, 0.78, 0.40),
                gold
            );

            float twinkle = 0.55 + 0.45 * sin(
                t * 2.4 + hash21(cell) * 2.0 * PI
            );

            result += color * starShape(q, 1.2, 0.0)
                    * envelope * fade * twinkle
                    * CLUSTER_BRIGHTNESS;
        }
    }

    // Faint irregular cloud glow
    result += vec3(0.045, 0.055, 0.10)
            * envelope * fade * CLUSTER_BRIGHTNESS;

    return result;
}

// Colored nebulae
vec3 nebulae(vec2 p, float t) {
    vec2 n1 = (p - vec2(-0.51, 0.20)) * 4.1;
    vec2 n2 = (p - vec2(0.57, -0.24)) * 4.7;
    vec2 n3 = (p - vec2(0.15, 0.49)) * 5.5;

    float mist1 = 0.0;
    float mist2 = 0.0;
    float mist3 = 0.0;

    if (dot(n1, n1) < 24.0) {
        float n = cloud(n1 + vec2(t * 0.004, 0.0));
        float m = smoothstep(0.43, 0.79, n);
        mist1 = m * m * exp(-dot(n1, n1) * 0.43);
    }

    if (dot(n2, n2) < 24.0) {
        float n = cloud(n2 - vec2(0.0, t * 0.003));
        float m = smoothstep(0.43, 0.79, n);
        mist2 = m * m * exp(-dot(n2, n2) * 0.37);
    }

    if (dot(n3, n3) < 24.0) {
        float n = cloud(n3);
        float m = smoothstep(0.48, 0.83, n);
        mist3 = m * m * exp(-dot(n3, n3) * 0.46);
    }

    float breath = 0.85 + 0.15 * sin(t * 0.13);

    return NEBULA_STRENGTH * breath * (
        vec3(0.12, 0.075, 0.25) * mist1
      + vec3(0.035, 0.19, 0.24) * mist2
      + vec3(0.22, 0.07, 0.16) * mist3
    );
}

float blackHolePresence(float t) {
    float cycle = 0.5 + 0.5 * cos(
        (t - 18.0) * 2.0 * PI / BLACK_HOLE_INTERVAL
    );

    return BLACK_HOLE_STRENGTH * (
        0.28 + 0.72 * smoothstep(0.45, 0.95, cycle)
    );
}

vec2 blackHoleCenter(float t) {
    float id = floor((t - 18.0) / BLACK_HOLE_INTERVAL + 0.5);

    return vec2(
        mix(-0.6, 0.6, hash21(vec2(id, 12.7))),
        mix(-0.3, 0.3, hash21(vec2(id, 37.1)))
    );
}

float blackHoleSize(float t) {
    float id = floor((t - 18.0) / BLACK_HOLE_INTERVAL + 0.5);
    float random = hash21(vec2(id, 54.3));

    return mix(
        BLACK_HOLE_MIN_SIZE,
        BLACK_HOLE_MAX_SIZE,
        pow(random, 3.0)
    );
}

float blackHoleShadow(vec2 d) {
    float d2 = dot(d, d);

    if (d2 >= 0.046 * 0.046)
        return 0.0;

    return 1.0 - smoothstep(0.039, 0.046, sqrt(d2));
}

// Blackhole with dim accretion disk and lensed light
vec3 blackHole(vec2 d, float t) {
    float d2 = dot(d, d);

    if (d2 > 0.12)
        return vec3(0.0);

    float r = sqrt(d2);
    float angle = atan(d.y, d.x);

    // Inclined accretion disk
    vec2 disk = vec2(d.x, d.y * 3.0);
    float rd = length(disk);
    float a = atan(disk.y, disk.x);
    float inner = smoothstep(0.052, 0.064, rd);
    float outer = 1.0 - smoothstep(0.125, 0.185, rd);
    float band = inner * outer;

    // Irregular gas brightness
    float turbulence = 0.72
        + 0.16 * sin(a * 5.0 - t * 0.11 + rd * 42.0)
        + 0.12 * sin(a * 11.0 + t * 0.07);

    // One side brighter than the other
    float doppler = mix(
        0.38, 1.0,
        smoothstep(-1.0, 1.0, cos(a + 0.4))
    );

    float heat = exp(-pow((rd - 0.068) / 0.045, 2.0));

    vec3 gasColor = mix(
        vec3(0.12, 0.008, 0.012),
        vec3(0.53, 0.105, 0.035),
        heat * doppler
    );

    vec3 gas = gasColor * band * turbulence * doppler;

    // Faint photon ring
    float ring = exp(-pow((r - 0.051) / 0.005, 2.0));
    float lensArc = 0.35 + 0.65 * pow(abs(sin(angle)), 1.8);
    vec3 lens = vec3(0.27, 0.065, 0.035) * ring * lensArc;

    // Light bent above and below
    float arc = exp(-pow((r - 0.065) / 0.011, 2.0));
    float arcMask = pow(abs(sin(angle)), 4.0);
    vec3 bentLight = vec3(0.16, 0.025, 0.022) * arc * arcMask;

    // Weak surrounding red haze
    float haze = exp(-pow(r / 0.16, 2.0));
    vec3 ambient = vec3(0.028, 0.003, 0.006) * haze;

    // Slowly changing luminosity
    float flicker = 0.94
                  + 0.04 * sin(t * 0.31)
                  + 0.02 * sin(t * 0.83);

    vec3 light = gas + lens + bentLight + ambient;

    // Dark event horizon
    light *= 1.0 - blackHoleShadow(d);

    return light * flicker;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 art = uv;

    if (FLIP_ART_Y == 1) art.y = 1.0 - art.y;

    vec2 p = (art - 0.5) * vec2(
        iResolution.x / iResolution.y, 1.0
    );

    float t = iTime;

    vec3 space = mix(
        vec3(0.0007, 0.0010, 0.0035),
        vec3(0.0030, 0.0045, 0.0110),
        0.35 + 0.35 * art.y
    );

    space += nebulae(p, t);
    space += distantStars(p, t, iResolution.y);
    space += forwardStars(p, t, iResolution.y);
    space += stellarClusters(p, t, iResolution.y);

    vec2 d = (p - blackHoleCenter(t)) / blackHoleSize(t);
    float presence = blackHolePresence(t);
    float shadow = blackHoleShadow(d);

    space *= 1.0 - shadow * presence;
    space += blackHole(d, t) * presence;

    // Preserve terminal text
    vec4 terminal = texture(iChannel0, uv);
    vec3 difference = abs(terminal.rgb - iBackgroundColor);
    float ink = max(difference.r, max(difference.g, difference.b));
    float textMask = smoothstep(0.035, 0.17, ink);

    vec3 bg = mix(
        iBackgroundColor, space,
        clamp(BACKGROUND_MIX, 0.0, 1.0)
    );

    fragColor = vec4(mix(bg, terminal.rgb, textMask), terminal.a);
}

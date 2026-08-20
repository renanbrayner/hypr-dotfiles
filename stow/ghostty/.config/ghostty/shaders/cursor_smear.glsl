// Cursor trail shader that creates a hexagonal trailing effect
//
// The effect works by:
// 1. Constructing a hexagon from current and previous cursor positions
// 2. Using signed distance fields (SDF) for smooth antialiased rendering
// 3. Animating the trailing corner with easing for fluid motion
// 4. Enhancing color saturation for visual impact

// ===== PARAMETERS - Modify these values to customize the shader =====

// Trail animation duration in seconds
// Controls how long the cursor trail remains visible after cursor movement
// Lower values (e.g., 0.1) = very short trail that fades quickly
// Higher values (e.g., 0.8) = long trail that stays visible longer
const float DURATION = 0.1;

// Color saturation boost factor
// Controls how vibrant the trail colors are compared to the original cursor color
// 1.0 = exact same color as cursor
// 1.5 = moderately more saturated/vibrant colors
// 2.0+ = highly saturated, neon-like colors
// Values below 1.0 will desaturate the trail colors
const float SATURATION_BOOST = 1.8;

// Scale factor for screen-independent coordinates
// Converts cursor position/size to normalized coordinates that work across different screen resolutions
// Affects the overall size and thickness of the trail
// Lower values (e.g., 1.0) = thinner, more subtle trail
// Higher values (e.g., 3.0) = thicker, more prominent trail
// This helps maintain consistent visual appearance across different display resolutions
const float SCALE_FACTOR = 1.5;

// Progress multiplier for double easing
// Controls the timing curve of the trail animation by creating two different easing speeds
// The trail corner moves at different speeds based on this multiplier
// 1.0 = linear motion (no easing effect)
// 2.0 = creates a smooth acceleration/deceleration effect
// Higher values create more dramatic "stretching" of the trail
// This is what gives the hexagonal trail its characteristic fluid motion
const float PROGRESS_MULTIPLIER = 2.0;

// Gray coefficients for color desaturation
// Weights for converting RGB color to grayscale (luminance calculation)
// These values represent human perception sensitivity to different colors:
// 0.299 = red contribution (humans see red more vividly)
// 0.587 = green contribution (humans see green most strongly)
// 0.114 = blue contribution (humans see blue least vividly)
// Used to create the gray base color before boosting saturation
const vec3 GRAY_COEFFICIENTS = vec3(0.299, 0.587, 0.114);

// Initial value for minimum distance calculation
// Starting value for the SDF (Signed Distance Field) minimum distance algorithm
// Used in hexagon collision detection to determine if a pixel is inside/outside the trail shape
// Large value (1e20) ensures first distance calculation will always be smaller
// This is an optimization to avoid initializing with a smaller distance
const float MIN_DIST_INITIAL = 1e20;

// ====================================================================

// Process each edge: compute distance and determine if point is inside
void processEdge(vec2 p, vec2 a, vec2 b, inout float minDist, inout float inside) {
    vec2 edge = b - a;
    vec2 pa = p - a;
    float lenSq = dot(edge, edge);
    float invLenSq = 1.0 / lenSq;

    float t = clamp(dot(pa, edge) * invLenSq, 0.0, 1.0);
    vec2 diff = pa - edge * t;
    minDist = min(minDist, dot(diff, diff));

    float cross = edge.x * pa.y - edge.y * pa.x;
    inside = min(inside, step(0.0, cross));
}

// Signed distance field for hexagon (negative inside, positive outside)
// Vertices must be in counter-clockwise order
float sdHexagon(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3, in vec2 v4, in vec2 v5) {
    float minDist = MIN_DIST_INITIAL;
    float inside = 1.0;

    processEdge(p, v0, v1, minDist, inside);
    processEdge(p, v1, v2, minDist, inside);
    processEdge(p, v2, v3, minDist, inside);
    processEdge(p, v3, v4, minDist, inside);
    processEdge(p, v4, v5, minDist, inside);
    processEdge(p, v5, v0, minDist, inside);

    float dist = sqrt(max(minDist, 0.0));
    return mix(dist, -dist, inside);
}

// Signed distance field for rectangle (negative inside, positive outside)
float sdRectangle(in vec2 p, in vec2 center, in vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Represents cursor as a quad with four corners
struct Quad {
    vec2 topLeft;
    vec2 topRight;
    vec2 bottomLeft;
    vec2 bottomRight;
};

// Construct quad from top-left position and size
Quad getQuad(vec2 pos, vec2 size) {
    Quad q;
    q.topLeft = pos;
    q.topRight = pos + vec2(size.x, 0.0);
    q.bottomLeft = pos - vec2(0.0, size.y);
    q.bottomRight = pos + vec2(size.x, -size.y);
    return q;
}

// Select 3 corners from quad based on movement direction
// sel.x: 0=left, 1=right | sel.y: 0=top, 1=bottom
// Returns corners in counter-clockwise order for hexagon construction
void selectTrailCorners(Quad q, vec2 sel, out vec2 p1, out vec2 p2, out vec2 p3) {
    p1 = mix(mix(q.topRight, q.topLeft, sel.x),
             mix(q.bottomRight, q.bottomLeft, sel.x),
             sel.y);

    p2 = mix(mix(q.topLeft, q.bottomLeft, sel.x),
             mix(q.topRight, q.bottomRight, sel.x),
             sel.y);
    p3 = mix(mix(q.bottomRight, q.topRight, sel.x),
             mix(q.bottomLeft, q.topLeft, sel.x),
             sel.y);
}

// Select 4 corners from quad based on movement direction
// sel.x: 0=left, 1=right | sel.y: 0=top, 1=bottom
// Returns corners in counter-clockwise order for hexagon construction
void selectCorners(Quad q, vec2 sel, out vec2 p1, out vec2 p2, out vec2 p3, out vec2 p4) {
    selectTrailCorners(q, sel, p1, p2, p3);

    p4 = mix(mix(q.bottomLeft, q.bottomRight, sel.x),
             mix(q.topLeft, q.topRight, sel.x),
             sel.y);
}

// Cubic ease-out function for smooth animation (expects clamped input)
float easeClamped(float x) {
    float t = 1.0 - x;
    return 1.0 - t * t * t;
}



void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Calculate animation progress with easing
    float baseProgress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);

    vec2 uv = fragCoord / iResolution.xy;
    vec4 background = texture(iChannel0, uv);

    // Skip further work when animation is complete
    if (baseProgress >= 1.0) {
        fragColor = background;
        return;
    }

    fragColor = background;

    // Precompute reused values
    float invResY = 1.0 / iResolution.y;
    float scale = SCALE_FACTOR * invResY;
    float aaWidth = scale;
    vec2 normOffset = iResolution.xy * invResY;

    // Normalize cursor positions and sizes to screen-independent coordinates
    vec2 currentPos = iCurrentCursor.xy * scale - normOffset;
    vec2 previousPos = iPreviousCursor.xy * scale - normOffset;
    vec2 currentSize = iCurrentCursor.zw * scale;
    vec2 previousSize = iPreviousCursor.zw * scale;

    // Determine movement direction and construct cursor quads
    vec2 deltaPos = currentPos - previousPos;
    Quad currentCursor = getQuad(currentPos, currentSize);
    Quad previousCursor = getQuad(previousPos, previousSize);
    vec2 selector = step(vec2(0.0), deltaPos);

    // Select corners based on movement direction
    vec2 currP1, currP2, currP3, currP4;
    vec2 prevP1, prevP2, prevP3;
    selectCorners(currentCursor, selector, currP1, currP2, currP3, currP4);
    selectTrailCorners(previousCursor, selector, prevP1, prevP2, prevP3);

    float easedProgress = easeClamped(baseProgress);
    float stretchedProgress = min(baseProgress * PROGRESS_MULTIPLIER, 1.0);
    float easedProgressDouble = easeClamped(stretchedProgress);

    // Create trailing effect by moving diagonal point slower
    vec2 trailP1 = mix(prevP1, currP1, easedProgress);
    vec2 trailP2 = mix(prevP2, currP2, easedProgressDouble);
    vec2 trailP3 = mix(prevP3, currP3, easedProgressDouble);

    // Compute hexagon SDF and convert to alpha with antialiasing
    vec2 normCoord = fragCoord * scale - normOffset;
    float sdfHex = sdHexagon(normCoord, trailP1, trailP2, currP2, currP4, currP3, trailP3);
    float alpha = 1.0 - smoothstep(-aaWidth, aaWidth, sdfHex);

    // Compute current cursor SDF
    vec2 halfCurrentSize = currentSize * 0.5;
    vec2 currentCenter = currentPos + vec2(halfCurrentSize.x, -halfCurrentSize.y);
    float sdfCurrentCursor = sdRectangle(normCoord, currentCenter, halfCurrentSize);

    // Enhance color saturation for more vibrant trail effect
    float gray = dot(iCurrentCursorColor.rgb, GRAY_COEFFICIENTS);
    vec4 enhancedColor = clamp(
        mix(vec4(vec3(gray), iCurrentCursorColor.a), iCurrentCursorColor, SATURATION_BOOST),
        0.0, 1.0
    );

    // Blend trail color with background
    vec4 originalColor = fragColor;
    fragColor.rgb = mix(fragColor.rgb, enhancedColor.rgb, alpha);

    // Remove trail where it overlaps with current cursor
    fragColor.rgb = mix(fragColor.rgb, originalColor.rgb, step(sdfCurrentCursor, 0.0));
}

// Original animated Christmas terminal art for Ghostty, created with ChatGPT
// Procedural character atlas, no extra textures / buffers / raymarching.
// This is a full-screen background; terminal glyphs are composited back on top.

#define CELL_HEIGHT 18.0      // 16-24 recommended: larger = chunkier ASCII
#define SCENE_STRENGTH 0.88   // reduce to 0.45 for distraction-free coding
#define SNOW_AMOUNT 0.72     // 0.0 to 1.0
#define LIGHT_SPEED 1.0      // 0.0 = frozen lights

float hash11(float x) { return fract(sin(x*127.17+19.63)*43758.5453); }
float hash21(vec2 p) { return fract(sin(dot(p, vec2(127.1,311.7)))*43758.5453); }
float bit(float b, float n) { return mod(floor(b / exp2(n)),2.0); }

// 5x7 glyph atlas. Glyph ids: 1 . 2 + 3 * 4 / 5 \\ 6 o 7 # 8 |
// 9 - 10 [ 11 ] 12 X 13 ^ 14 : 15 = 16 ~ 17 @ 18 $ 19 % 20 ( 21 )
// 22 M 23 E 24 R 25 Y 26 C 27 H 28 I 29 S 30 T 31 A
float rowBits(int g,int r) {
    if(g==1)  return r==5 ? 4.0 : 0.0;
    if(g==2)  return r==3 ? 31.0 : ((r>=1&&r<=5)?4.0:0.0);
    if(g==3)  return (r==0||r==6)?4.0:((r==1||r==5)?21.0:((r==2||r==4)?14.0:31.0));
    if(g==4)  return exp2(float(r));
    if(g==5)  return exp2(float(4-r));
    if(g==6)  return (r==0||r==6)?14.0:17.0;
    if(g==7)  return (r==2||r==4)?31.0:10.0;
    if(g==8)  return 4.0;
    if(g==9)  return r==3?31.0:0.0;
    if(g==10) return (r==0||r==6)?14.0:8.0;
    if(g==11) return (r==0||r==6)?14.0:2.0;
    if(g==12) return r==3?4.0:((r==2||r==4)?10.0:17.0);
    if(g==13) return r==0?4.0:(r==1?10.0:(r==2?17.0:0.0));
    if(g==14) return (r==2||r==5)?4.0:0.0;
    if(g==15) return (r==2||r==4)?31.0:0.0;
    if(g==16) return (r==2)?9.0:(r==3?22.0:0.0);
    if(g==17) return (r==0||r==6)?14.0:((r==3)?23.0:((r==4)?16.0:17.0));
    if(g==18) return (r==0||r==3||r==6)?14.0:((r==1||r==2)?20.0:5.0);
    if(g==19) return (r==0||r==6)?17.0:((r==1||r==5)?18.0:(r==3?4.0:9.0));
    if(g==20) return r==0||r==6?2.0:(r==1||r==5?4.0:(r==2||r==4?8.0:16.0));
    if(g==21) return r==0||r==6?8.0:(r==1||r==5?4.0:(r==2||r==4?2.0:1.0));
    if(g==22) return r==0?17.0:(r==1?27.0:(r==2?21.0:17.0)); // M
    if(g==23) return (r==0||r==3||r==6)?31.0:16.0; // E
    if(g==24) return r==0?30.0:(r==3?30.0:(r==1||r==2?17.0:(r==4?20.0:(r==5?18.0:17.0)))); // R
    if(g==25) return (r==0||r==1)?17.0:(r==2?10.0:4.0); // Y
    if(g==26) return (r==0||r==6)?15.0:16.0; // C
    if(g==27) return r==3?31.0:17.0; // H
    if(g==28) return (r==0||r==6)?31.0:4.0; // I
    if(g==29) return (r==0||r==3||r==6)?15.0:(r<3?16.0:1.0); // S
    if(g==30) return r==0?31.0:4.0; // T
    if(g==31) return r==0?4.0:(r==1?10.0:(r==3?31.0:17.0)); // A
    return 0.0;
}

float glyph(vec2 local,int g) {
    vec2 q=floor(vec2(local.x*7.0-1.0, local.y*9.0-1.0));
    if(q.x<0.0 || q.y<0.0 || q.x>=5.0 || q.y>=7.0) return 0.0;
    return bit(rowBits(g,int(q.y)),4.0-q.x);
}

vec3 bulbColor(float s) {
    if(s < 0.2) return vec3(1.0,0.17,0.23);
    if(s < 0.4) return vec3(1.0,0.78,0.25);
    if(s < 0.6) return vec3(0.20,0.78,1.0);
    if(s < 0.8) return vec3(1.0,0.32,0.86);
    return vec3(0.52,1.0,0.55);
}

void mainImage(out vec4 fragColor,in vec2 fragCoord) {
    vec2 uv = fragCoord/iResolution.xy;
    vec2 xy = vec2(fragCoord.x,iResolution.y-fragCoord.y); // Art only: Ghostty top-origin correction
    vec2 cp = (xy-0.5*iResolution.xy)/vec2(CELL_HEIGHT*0.64,CELL_HEIGHT);
    vec2 cell = floor(cp+0.5);
    vec2 local = fract(cp+0.5);
    float x=cell.x;
    float y=cell.y; // Positive Y points UP in the artwork
    float t=iTime*LIGHT_SPEED;
    float r=hash21(cell+vec2(17.0,93.0));
    float w=iResolution.x/iResolution.y;
    int g=0;
    vec3 ink=vec3(0.75,0.86,0.97);
    float bloom=0.0;

    // Winter midnight background + tiny halo behind the tree.
    float v=xy.y/iResolution.y;
    vec3 scene=mix(vec3(0.013,0.021,0.060),vec3(0.026,0.072,0.118),1.0-v);
    float aura=exp(-pow((uv.x-0.5)*2.6,2.0)-pow((v-0.47)*2.2,2.0));
    scene += vec3(0.015,0.036,0.044)*aura;
    // Moon in the far-right upper corner, behind the art.
    vec2 moon=(uv-vec2(0.83,0.20))*vec2(w,1.0);
    scene+=vec3(0.054,0.088,0.135)*exp(-dot(moon,moon)*390.0);

    // Two moving grids of lightweight character snow: no per-particle loops.
    for(int l=0;l<2;l++) {
        float z=float(l);
        vec2 drift=cp+vec2(t*(0.28+z*0.21),-iTime*(0.58+z*0.46));
        vec2 si=floor(drift+0.5);
        float h=hash21(si+z*71.63);
        if(h>0.958+z*0.015) {
            vec2 sl=fract(drift+0.5);
            int sg=h>0.992?3:(h>0.981?2:1);
            float a=glyph(sl,sg)*(0.28+0.28*h)*SNOW_AMOUNT;
            scene+=a*vec3(0.18,0.30,0.42);
        }
    }

    // Decorative night stars outside the Christmas tree.
    if(abs(x)>17.0 && y>-13.0 && hash21(cell+vec2(111.0,77.0))>0.985) {
        g=r>0.7?3:(r>0.4?2:1);
        ink=vec3(0.28,0.47,0.64)*(0.75+0.25*sin(iTime*0.7+r*9.0));
    }

    // Wider, tiered boughs with independently shaded evergreen ASCII symbols.
    // 23 rows tall, 3 overlapping cones / branch shelves.
    if(y>=-9.0 && y<=13.0) {
        float row=13.0-y;
        float tier=clamp(floor(row/7.5),0.0,2.0);
        float within=mod(row,7.5);
        float width=floor(1.0+tier*2.0+within*(0.91+0.17*tier));
        float edge=abs(x);
        if(edge<=width) {
            float n=hash21(cell+vec2(27.0,13.0));
            // Pine-needle texture, multiple leafy greens, subtle vertical shading.
            g=n<0.14?3:(n<0.36?12:(n<0.67?13:(n<0.88?7:16)));
            ink=mix(vec3(0.037,0.31,0.17),vec3(0.23,0.75,0.37),n);
            ink*=0.82+0.18*(1.0-edge/max(width,1.0));
            if(edge==width) {
                g=x<0.0?4:5;
                ink=vec3(0.22,0.65,0.35);
            }
            if(within>=6.5 && edge<width-1.0) {g=16; ink=vec3(0.16,0.52,0.28);}

            // S-shaped gold garlands cascade across the fir branches.
            float cord = sin((x/(max(width,2.0)))*3.14159*1.35+float(tier)*1.8)*1.8;
            float garlandRow = 5.0 - 7.5*tier + cord;
            if(abs(y-garlandRow)<0.52 && edge<width-1.0) {
                g= (mod(x+floor(tier),4.0)==0.0)?3:16;
                ink=vec3(0.94,0.57,0.13)*(0.86+0.14*sin(t*0.7+x));
                bloom=0.10;
            }

            // Colorful, synchronized-but-not-identical lights / glossy ornaments.
            float b=hash21(cell+vec2(85.19,22.37));
            if(b>0.805 && edge<width-0.6) {
                float sel=hash21(cell+vec2(47.3,168.5));
                ink=bulbColor(sel);
                g=b>0.945?17:(b>0.87?6:3);
                float flash=0.62+0.38*sin(2.7*t + x*0.85 + y*1.9 + b*13.0);
                flash=0.56+0.44*flash;
                ink*=flash;
                bloom=0.18+0.19*flash;
            }
            // Needle highlights shimmer much less frequently than ornaments.
            else if(n>0.93) ink*=0.90+0.10*sin(t*0.6+n*50.0);
        }
    }

    // Brilliant cross-shaped star topper + pulsing, localized corona.
    if((x==0.0 && y>=14.0 && y<=17.0) || (y==15.0 && abs(x)<=2.0) ||
       (y==16.0 && abs(x)<=1.0)) {
        g=(x==0.0 && y==16.0)?17:3;
        float pul=0.86+0.14*sin(t*2.6);
        ink=vec3(1.0,0.78,0.25)*pul;
        bloom=0.35+0.20*pul;
    }
    // Actual continuous glow around the topper; only a few pixels of work.
    vec2 starDist=(cp-vec2(0.0,15.5))*vec2(0.85,1.0);
    scene+=vec3(0.10,0.065,0.008)*exp(-dot(starDist,starDist)*0.09)*(0.75+0.25*sin(t*2.1));

    // Wooden trunk, with a softly illuminated base.
    if(y>=-12.0 && y<=-10.0 && abs(x)<=1.0) {
        g=x==0.0?7:8;
        ink=vec3(0.59,0.33,0.15);
    }

    // Wrapped ASCII presents at the foot: red, blue and purple with gold ribbons.
    if(y>=-17.0 && y<=-13.0) {
        for(int i=0;i<3;i++) {
            float cx=(float(i)-1.0)*8.0;
            float dx=x-cx;
            if(abs(dx)<=3.0) {
                if(y==-13.0) g=(dx==0.0)?3:9;
                else if(y==-17.0) g=15;
                else if(abs(dx)==3.0) g=8;
                else if(dx==0.0) g=8;
                else if(y==-15.0) g=15;
                else g=hash21(cell+float(i)*23.0)>0.6?17:7;
                ink=i==0?vec3(1.0,0.21,0.28):(i==1?vec3(0.13,0.65,1.0):vec3(0.80,0.32,0.93));
                if(dx==0.0 || y==-15.0) ink=vec3(1.0,0.75,0.25);
                bloom=(dx==0.0 && y==-13.0)?0.15:0.0;
            }
        }
    }

    // Decorative snow-bank glyphs below the presents.
    if(y==-18.0 && abs(x)<24.0 && r>0.4 && g==0) {
        g=r>0.82?3:1;
        ink=vec3(0.43,0.68,0.83);
    }

    // Shine a very small halo inside each lit character cell.
    scene+=ink*bloom*exp(-length(local-vec2(0.5))*4.0);
    float drawn=glyph(local,g);
    scene=mix(scene,ink,drawn*0.94);

    // Preserve terminal foreground + cursor from unmodified iChannel0.
    vec4 terminal=texture(iChannel0,uv);
    vec3 delta=abs(terminal.rgb-iBackgroundColor);
    float textMask=smoothstep(0.035,0.16,max(max(delta.r,delta.g),delta.b));
    vec3 result=mix(iBackgroundColor,scene,SCENE_STRENGTH);
    result=mix(result,terminal.rgb,textMask);
    fragColor=vec4(result,terminal.a);
}

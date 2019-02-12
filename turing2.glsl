#include <common>
#include <packing>

const float WEIGHT=0.2;
const float EFFECT=0.2;

varying vec2 vUv;
uniform float screenWidth;
uniform float screenHeight;
uniform sampler2D frameTexture;
uniform float time;
float sx;
float sy;

vec2 wrap(vec2 coords) {
  vec2 res;
  res = vec2(coords);
  if(res.x < 0.00) {
    res.x += 1.0;
  } else if(res.x > 1.0) {
    res.x -= 1.0;
  }
  if(res.y < 0.00) {
    res.y += 1.0;
  } else if(res.y > 1.0) {
    res.y -= 1.0;
  }
  return res;
}

float length(vec2 a, vec2 b) {
  return sqrt((a.x - b.x)*(a.x - b.x) + (a.y - b.y)*(a.y - b.y));
}

float averageCircle8(vec2 center) {
  float count;
  float sum;
  count = 0.0;
  sum = 0.0;
  for(float i = -8.0; i <= 8.0; i += 1.) {
    for(float j = -8.0; j <= 8.0; j += 1.) {
      //this isn't exactly the same thing
      if(length(vec2(i,j),vec2(0.0,0.0)) <= 8.0) {
        count += 1.0;
        sum += texture2D(frameTexture, wrap(center + vec2(i*sx,j*sy))).r;
      }
    }
  }
  return sum / count;
}

float averageCircle4(vec2 center) {
  float count;
  float sum;
  count = 0.0;
  sum = 0.0;
  for(float i = -4.0; i <= 4.0; i += 1.) {
    for(float j = -4.0; j <= 4.0; j += 1.) {
      //this isn't exactly the same thing
      if(length(vec2(i,j),vec2(0.0,0.0)) <= 4.0) {
        count += 1.0;
        sum += texture2D(frameTexture, wrap(center + vec2(i*sx,j*sy))).r;
      }
    }
  }
  return sum / count;
}

void main() {
  sx = 1.0/screenWidth;
  sy = 1.0/screenHeight;
  
  float activator, inhibitor;
  activator = averageCircle4(vUv) * WEIGHT;
  inhibitor = averageCircle8(vUv) * WEIGHT;
  gl_FragColor = vec4(
    activator,
    inhibitor, //inhibitor
    0.0,
    EFFECT
  );
}
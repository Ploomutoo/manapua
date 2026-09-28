//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

const float speed = 0.002;
const float Xfrequency = 20.0;
const float Yfrequency = 26.0;
const float size = 0.005;

void main()
{
	float Horizontal_Wave = sin(time * speed + v_vTexcoord.y * Xfrequency) * (size * v_vTexcoord.x);
	float Vertical_Wave = sin(time * speed + v_vTexcoord.x * Yfrequency) * (size * v_vTexcoord.y);
	
	vec4 distort = v_vColour * texture2D( gm_BaseTexture, vec2( v_vTexcoord.x + Horizontal_Wave , v_vTexcoord.y + Vertical_Wave) );
	
    gl_FragColor = distort;
}

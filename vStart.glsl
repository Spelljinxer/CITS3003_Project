attribute vec3 vPosition;
varying vec3 position;

attribute vec3 vNormal;
varying vec3 normal;

attribute vec2 vTexCoord;
varying vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{

    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;
    
    gl_Position = Projection * ModelView * vpos;

    position = pos;
    normal = vNormal;
    texCoord = vTexCoord;

}

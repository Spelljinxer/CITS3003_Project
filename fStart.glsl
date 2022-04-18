varying vec3 position;
varying vec3 normal;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

vec4 color;
uniform sampler2D texture;

//TASK G - moving variables to fragment shader
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform vec4 LightPosition;
uniform float Shininess;

uniform float LightBrightness;


void main()
{
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - position;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -position );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct * LightBrightness;


    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );

    vec3 specular = Ks * (SpecularProduct * LightBrightness);
    
    
    if (dot(L, N) < 0.0 ) {
        specular = vec3(0.0, 0.0, 0.0);
    } 

    //TASK F 
    float lightDist = 0.2 + length(Lvec);
    float light = 1.0/(1.0 + 1.0*length(Lvec) + lightDist);
    //ENDOF TASK F


    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient + ((ambient + diffuse) / lightDist) + specular + light;
    color.a = 1.0;

    gl_FragColor = color * texture2D( texture, texCoord * 2.0);
}

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
uniform vec3 LightColor;

//TASK I - SECOND LIGHT
uniform vec4 LightPosition2;
uniform vec3 LightBrightness2;
uniform vec3 LightColor2;

uniform mat4 Projection;

void main()
{
    // The vector to the light from the vertex   
    vec3 Lvec = LightPosition.xyz - position;

    vec3 Lvec2 = LightPosition2.xyz - position;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 L2 = normalize( Lvec2 ); 
    vec3 E = normalize( -position);   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector
    vec3 H2 = normalize(L2 + E);

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct * (LightColor * LightBrightness);
    vec3 ambient2 = AmbientProduct * (LightColor2 * LightBrightness2);


    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct;

    float Kd2 = max(dot(L2, N), 0.0);
    vec3  diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3 specular = Ks * LightBrightness * SpecularProduct;

    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct;
    
    
    if (dot(L, N) < 0.0 ) {
        specular = vec3(0.0, 0.0, 0.0);
    } 
    if(dot(L2, N) < 0.0) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }

    //TASK F 
    float light_distance = 0.1 + length(Lvec);
    float light = 1.0/(1.0 + 1.0*length(Lvec) + light_distance);
    //ENDOF TASK F

    float light_distance_2 = 0.1 + length(Lvec2);
    float light2 = 1.0/(1.0 + 1.0*length(Lvec2) + light_distance_2);

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient + ((ambient + diffuse) / light_distance) + specular + light + light2;
    color.a = 1.0;

    gl_FragColor = color * texture2D( texture, texCoord * 2.0);
}



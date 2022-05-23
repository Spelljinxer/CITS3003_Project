varying vec3 position;
varying vec3 normal;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

vec4 color;
vec4 colour_3;
uniform sampler2D texture;

uniform mat4 Projection;
uniform float texScale;

//TASK G - moving variables to fragment shader
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform float Shininess;
uniform vec4 LightPosition;
uniform float LightBrightness;
uniform vec3 LightColor;

//TASK I - SECOND LIGHT
uniform vec4 LightPosition2;
uniform float LightBrightness2;
uniform vec3 LightColor2;

//TASK J - SPOTLIGHT
uniform vec4 LightPosition3;
uniform float LightBrightness3;
uniform vec3 LightColor3;
uniform float lateral;
uniform float vertical;

void main()
{
    // The vector to the light from the vertex   
    vec3 Lvec = LightPosition.xyz - position;

    vec3 Lvec2 = LightPosition2.xyz;
   
    vec3 Lvec3 = LightPosition3.xyz - position;
    
    //used for chaning direction of light 3
    vec3 direct;
    direct.x = cos(radians(vertical))*cos(radians(lateral));
    direct.y = sin(radians(lateral));
    direct.z = sin(radians(vertical))*cos(radians(lateral));
    
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 L2 = normalize( Lvec2 ); 
    vec3 L3 = normalize( Lvec3 );
    vec3 E = normalize( -position);   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E);
    
    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );
   
   // Compute terms in the illumination equation
    vec3 ambient = (LightColor * LightBrightness) + AmbientProduct;
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct;
    vec3 ambient3 = (LightColor3 * LightBrightness3) * AmbientProduct;
    float theta = dot(L3, normalize(-direct));

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct;
    float Kd2 = max(dot(L2, N), 0.0);
    vec3  diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct;
    float Kd3 = max(theta, 0.0);
    vec3  diffuse3 = Kd3 * (LightColor3 * LightBrightness3) * DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    float Ks3 = pow( max(theta, 0.0), Shininess );

    vec3 brightness = vec3(2,2,2);
    vec3 specular = Ks * (SpecularProduct + brightness);
    vec3 specular2 = Ks2 * (SpecularProduct + brightness);
    vec3 specular3 = Ks3 * LightBrightness3 * SpecularProduct;

    if (dot(L, N) < 0.0 ) {
        specular = vec3(0.0, 0.0, 0.0);
    } 
    if(dot(L2, N) < 0.0) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }
    if(theta < 0.0) {
        specular3 = vec3(0.0, 0.0, 0.0);
    }

    //TASK F 
    float light_distance = 0.1 + length(Lvec);
    float light = 1.0/(1.0 + 1.0*length(Lvec) + light_distance * light_distance);
    //ENDOF TASK F

    //Task J
    float light_distance_3 = 0.1 + length(Lvec3);
    if (theta > 0.9){
        colour_3 = vec4(ambient3 + light_distance_3 * (diffuse3), 1.0);
    }
    else{
        colour_3 = vec4(ambient3, 1.0);
    }
    //End Task J
    
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient + ((ambient + diffuse + specular) * light) + ambient2 + diffuse2;
    color.a = 1.0;
    
    gl_FragColor = (color + colour_3) * texture2D(texture, texCoord * texScale);

}


layout(location=0) out vec3 fragColorPosition;
layout(location=1) out vec3 fragColorVelocity;
layout(location=2) out vec4 fragColorColor;

uniform float dt;
uniform float springConstant;
uniform float restLength;
uniform float dampingConstant;
uniform float viscousDrag;
uniform float anchorForce;
uniform float impulseForce;
uniform float mass;
uniform int reset;

vec2 springs[2] = vec2[2](vec2(-1.,0.), vec2(1.,0.));

const int POSITION = 0;
const int VELOCITY = 1;
const int VELOCITY_NEW = 2;
const int ANCHOR = 3;

const float smallf = 0.000001;


///////////////////////////////////////////////////////////
// M A I N
///////////////////////////////////////////////////////////
void main() {

    // Calculate forces
    // viscous drag
    vec3 pos0 = texture2D(sTD2DInputs[POSITION], vUV.st).xyz;
    vec3 vel0 = texture2D(sTD2DInputs[VELOCITY], vUV.st).xyz;
    vec3 vel_new = texture2D(sTD2DInputs[VELOCITY_NEW], pos0.xy).xyz; 
    vec3 anchor = texture2D(sTD2DInputs[ANCHOR], vUV.st).xyz;
    vec3 force = vec3(0.);



    force -= viscousDrag * vel0; // viscous drag * velocity   
    force += vel_new * dt * dt * impulseForce;
    force += (anchor-pos0) * anchorForce;


    // spring interaction
    // 1d horizontal connection
    float cellSize = uTD2DInfos[POSITION].res.x;

    for (int i = 0; i < 2; i++) {
        vec2 offset = vec2(cellSize, 0.);
        offset *= springs[i];
        vec2 coord = vUV.st + offset;
        
        if (coord.x < 0.) coord.x = 1.-cellSize;
        if (coord.x > 1.) coord.x = 0.+cellSize;

        vec3 pos1 = texture2D(sTD2DInputs[POSITION], coord).xyz;
        vec3 vel1 = texture2D(sTD2DInputs[VELOCITY], coord).xyz;

        vec3 dx = pos0 - pos1;
        float len = length(dx);
        vec3 f = vec3(0.);

        if (len != 0.0) {
            f = vec3(springConstant * (len - restLength)); // spring constant * (magnitude - restLength)
            f += dampingConstant * (vel0 - vel1) * dx/vec3(len); // damping constant * (ve1-vel2) * (dx/magnitude);
            f *= -dx/vec3(len);
        }

        force += f;

    }


    // Apply derivative
    if (reset > 0) {
        force = vec3(0.);
        vel0 = vec3(0.);
    }

    vec3 dpdt = vel0;
    vec3 dvdt = force/vec3(mass);  // force/mass

    pos0 += dpdt * dt;
    vel0 += dvdt * dt;

    vec4 color = vec4(1.);

    fragColorPosition = pos0;
    fragColorVelocity = vel0; 
    fragColorColor = color; 

} //main

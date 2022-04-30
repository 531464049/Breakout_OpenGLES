#version 300 es

precision highp float;
in vec2 TexCoords;

uniform sampler2D spriteTexture;
uniform vec3 spriteColor;

out vec4 FragColor;

void main()
{
    FragColor = vec4(spriteColor, 1.0) * texture(spriteTexture, TexCoords);
}


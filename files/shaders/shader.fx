float4 colorA = float4(0, 0, 0, 0);
float4 colorB = float4(1, 1, 1, 1);
float glow = M_glow;
float speed = M_speed;
float rate = M_rate;
float frequency = M_frequency;
float amplitude = M_amplitude;

float4x4 WorldViewProjection;
float Time;

#include "mta-helper.fx"

#define TAU 6.28318530718

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    PS.TexCoord = VS.TexCoord;
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float x = cos(PS.TexCoord.x * TAU * frequency) * amplitude;
    float wave = frac((PS.TexCoord.y + x + Time * speed) * rate) + glow;
    float4 gradient = lerp(colorA, colorB, PS.TexCoord.y);

    return (gradient * wave) * PS.TexCoord.y;
}

technique
{
    pass P0
    {
        SrcBlend = SrcColor;
        DestBlend = One;
        SeparateAlphaBlendEnable = true;

        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader  = compile ps_3_0 PixelShaderFunction();
    }
}

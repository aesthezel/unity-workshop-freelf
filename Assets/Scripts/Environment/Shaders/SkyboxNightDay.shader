Shader "Freelf/Environment/SkyboxNightDay"
{
    Properties
    {
        _TextureDay ("Day Texture", 2D) = "white" {}
        _TextureNight ("Night Texture", 2D) = "white" {}
        _Blend ("Blend", Range(0,1)) = 0.5
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 texcoord : TEXCOORD0;
            };

            sampler2D _TextureDay;
            sampler2D _TextureNight;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.texcoord = v.vertex.xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float2 ToRadialCoords(float3 coords)
            {
                float3 normalizedCoords = normalize(coords);
                float latitude = acos(normalizedCoords.y);
                float longitude = atan2(normalizedCoords.z, normalizedCoords.x); 
                const float2 sphereCoords = float2(longitude, latitude) * float2(0.5 / UNITY_PI, 1.0 / UNITY_PI);
                return float2(0.5, 1.0) - sphereCoords;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 textureCoordinates = ToRadialCoords(i.texcoord);
                float4 day = tex2D(_TextureDay, textureCoordinates);
                float4 night = tex2D(_TextureNight, textureCoordinates);
                return lerp(day, night, _Blend);
            }

            ENDCG
        }
    }
}

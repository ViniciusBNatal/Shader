//shader com calculo de luz
Shader "lit/mylit"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color:COLOR;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color:COLOR;
                float3 normal:NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;

                float3 vertex = v.vertex * float3(1.5, 1, 1)
                    + float3(0,sin(5.0 * _Time.z + v.vertex.x),0);

                o.vertex = UnityObjectToClipPos(vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float3 norm = float3((2 + sin(5.0 * _Time.z + v.vertex.x)) / 2,5,v.normal.z);

                o.normal = norm;
                o.color = v.color;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 wnormal = normalize(mul(float4(i.normal, 0.0),unity_WorldToObject)).xyz;
                float3 lightpos = normalize(_WorldSpaceLightPos0).xyz;
                float finalcolor = dot(wnormal, lightpos);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * finalcolor*3;

                return col;
            }
            ENDCG
        }
    }
}

Shader "Unlit/EX2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100        
        // float 32 bit, half 16 bits, fixed 1 byte
        // float > half > fixed
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                // o valor do vertex é enviado para a var POSITION
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // entra appdata e retorna na função v2f
            v2f vert (appdata v)
            {
                //isso cria avar para sair, ela se chama o;
                v2f o;

                float3 vertex = v.vertex * float3(1.5, 1, 1) + float3(0, sin(4.0 * _Time.z + v.vertex.x), 0);
                o.vertex = UnityObjectToClipPos(vertex);
                o.normal = v.normal;
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 wnormal = normalize(mul(float4(i.normal, 0.0), unity_WorldToObject)).xyz;
                float3 lightpos = normalize(_WorldSpaceLightPos0).xyz;
                float finalcolor = dot(wnormal, lightpos);
                // sample the texture
                fixed4 col;

                if (i.uv.y <= .3) {
                    col = tex2D(_MainTex, i.uv) * finalcolor * float4(1,0,0,1);
                }
                else if (i.uv.y > .3 && i.uv.y <= .6) {
                    col = tex2D(_MainTex, i.uv) * finalcolor * float4(0, 1, 0, 1);;
                }
                else {
                    col = tex2D(_MainTex, i.uv) * finalcolor * float4(0, 0, 1, 1);;
                }
                
                return col;
            }
            ENDCG
        }
    }
}

Shader "Custom/LitFur"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _FurTex("Base (RGB)", 2D) = "white" {}
        _Ajust("FurSize",float) = 1
        _Color("Base Color", Color) = (1,1,1,1)
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"
            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 color:COLOR;
                float3 normal:NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                float4 color:COLOR;
                float3 normal:NORMAL;
                UNITY_VERTEX_OUTPUT_STEREO
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            v2f vert(appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            fixed4 frag(v2f i) : SV_Target
            {
                float3 wnormal = normalize(mul(float4(i.normal, 0.0),unity_WorldToObject)).xyz;
                float3 lightpos = normalize(_WorldSpaceLightPos0).xyz;
                float finalcolor = dot(wnormal, lightpos);
                fixed4 col = tex2D(_MainTex, i.texcoord) * _Color * finalcolor;
                UNITY_APPLY_FOG(i.fogCoord, col);
                // UNITY_OPAQUE_ALPHA(col.a);
                return col;
            }
            ENDCG
        }
    }
}

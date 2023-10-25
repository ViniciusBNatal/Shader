Shader "Unlit/GeometryShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Diffuse Material Color", Color) = (1,1,1,1)
        _Heigth("Height", Float) = 1
        _Lenght("Lenght", Float) = 1
        _Speed("Speed", Float) = 1
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Cull off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geo
            // make fog work
            #pragma multi_compile_fog



            #include "UnityCG.cginc"

            float rand(float2 co) 
            {
                return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
            }



            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
                float4 color: COLOR;
            };



            struct v2g
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 normal : NORMAL;
                float4 color: COLOR;
            };
            struct g2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 normal : NORMAL;
                float4 color: COLOR;
            };



            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Heigth;
            float _Lenght;
            float _Speed;
            v2g vert(appdata v)
            {
                v2g o;
                //o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex = v.vertex;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = v.normal;
                o.color = v.color;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }



            [maxvertexcount(12)]
            void geo(triangle v2g index[3], inout TriangleStream<g2f> triStream)
            {
                v2g o;
                for (int i = 0; i < 3; i++) {
                    o.vertex = UnityObjectToClipPos(index[i].vertex);
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    triStream.Append(o);
                }
                triStream.RestartStrip();

                float mov;
                float4 middlePoint;
                float random;

                for (int i = 0; i < 1; i++) {
                    mov = cos(_Time.w + index[i].vertex.x) * _Speed;
                    random = rand(index[i].uv);

                    o.vertex = UnityObjectToClipPos(index[i].vertex + index[i].normal * _Heigth + random * mov);
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    triStream.Append(o);

                    o.vertex = UnityObjectToClipPos(index[i].vertex) + float4(_Lenght + random,0,0,0);
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    triStream.Append(o);

                    o.vertex = UnityObjectToClipPos(index[i].vertex) + float4(-_Lenght + random, 0, 0, 0);
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    triStream.Append(o);
                }




            }



            fixed4 frag(g2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * i.color * _Color;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
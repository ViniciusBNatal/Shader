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
                o.vertex = UnityObjectToClipPos(v.vertex);
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
                    o.vertex = index[i].vertex;
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    triStream.Append(o);
                }
                triStream.RestartStrip();

                //float4 faceNormal = float4(normalize(cross(index[1].vertex - index[0].vertex, index[2].vertex - index[0].vertex)), 1);

                /*for (int i = 0; i < 3; i++) {
                    o.vertex = index[i].vertex + index[i].normal * 0.5 * sin(_Time.z);
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    triStream.Append(o);
                }*/
                float4 mov;
                float4 middlePoint;
                for (int i = 0; i < 3; i++) {
                    mov = float4(sin(_Time.y + o.vertex.x) * _Speed, 0, 0, 0);
                    //middlePoint = index[0].vertex + index[1].vertex / 2.0;
                    //o.vertex = (middlePoint - index[0].normal * _Heigth) + mov;
                    o.vertex = (index[i].vertex - index[0].normal * _Heigth) + mov;
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    triStream.Append(o);

                    o.vertex = index[i].vertex + float4(_Lenght,0,0,0);
                    o.uv = index[i].uv;
                    o.normal = index[i].normal;
                    o.color = index[i].color;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    triStream.Append(o);

                    o.vertex = index[i].vertex + float4(_Lenght, 0, 0, 0);
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
Shader "lit/ocean"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Normal("Texture", 2D) = "white" {}
        _Color("Diffuse Material Color", Color) = (1,1,1,1)

      _Shininess("Shininess", Float) = 10
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
                float _Shininess;
                float4 _MainTex_ST;
                sampler2D _Normal;
                v2f vert(appdata v)
                {
                    v2f o;



                    float wave = sin(_Time.z + v.vertex.x);
                    float wave2 = cos(_Time.z + v.vertex.x);
                    float3 vertex = v.vertex + float3(0, wave2, wave) * 0.2;
                    float3 norm = UnityObjectToWorldNormal(float4(v.normal, 1));



                    o.vertex = UnityObjectToClipPos(vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.normal = normalize(norm);
                    o.color = v.color;

                    return o;
                }



                fixed4 frag(v2f i) : SV_Target
                {
                    //float3 wnormal = normalize(mul(float4(i.normal, 0.0),unity_WorldToObject)).xyz;



                    half3 wNormal = normalize(i.normal + tex2D(_Normal, i.uv + _Time.x) * tex2D(_Normal, i.uv.yx - _Time.x));
                    float3 lightpos = normalize(_WorldSpaceLightPos0).xyz;
                    float finalcolor = dot(wNormal, lightpos);
                    float3 viewDirection = normalize(_WorldSpaceCameraPos
                        - mul(unity_ObjectToWorld, i.vertex).xyz);



                    float3 specularReflection;
                    if (dot(wNormal, lightpos) < 0.0)

                    {
                        specularReflection = float3(0.0, 0.0, 0.0);

                    }
                    else
                    {
                        specularReflection = _Shininess *
                             pow(max(0.0, dot(
                                reflect(-lightpos, wNormal),
                                viewDirection)), 1);
                    }




                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv) * finalcolor;


                    return col + float4(specularReflection,1);
                }
                ENDCG
            }
        }
}
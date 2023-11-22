// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)
// Unlit shader. Simplest possible textured shader.
// - no lighting
// - no lightmap support
// - no per-material color
Shader "Unlit/TransparentTexture" {
    Properties{
        _MainTex("Base (RGB)", 2D) = "white" {}
        _FurTex("Base (RGB)", 2D) = "white" {}
        _Ajust("FurSize",float) = 1
        _Color("Base Color", Color) = (1,1,1,1)
    }
        SubShader{
            Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }
            LOD 100
            Blend SrcAlpha OneMinusSrcAlpha
            Pass {
                CGPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma target 2.0
                    #include "UnityCG.cginc"
                    struct appdata_t {
                        float4 vertex : POSITION;
                        float2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                    };
                    struct v2f {
                        float4 vertex : SV_POSITION;
                        float2 texcoord : TEXCOORD0;
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
                        fixed4 col = tex2D(_MainTex, i.texcoord);
                        col *= _Color;
                        UNITY_APPLY_FOG(i.fogCoord, col);
                        // UNITY_OPAQUE_ALPHA(col.a);
                        return col;
                    }
                ENDCG
            }
            Pass {
                CGPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma target 2.0
                    #include "UnityCG.cginc"
                    struct appdata_t {
                        float4 vertex : POSITION;
                        float4 normal : NORMAL;
                        float2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                    };
                    struct v2f {
                        float4 vertex : SV_POSITION;
                        float4 normal : NORMAL;
                        float2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_OUTPUT_STEREO
                    };
                    sampler2D _MainTex;
                    sampler2D _FurTex;
                    float4 _FurTex_ST;
                    float4 _Color;
                    float _Ajust;
                    v2f vert(appdata_t v)
                    {
                        v2f o;
                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                        o.vertex = UnityObjectToClipPos(v.vertex+v.normal * _Ajust);
                        o.texcoord = TRANSFORM_TEX(v.texcoord, _FurTex);
                        UNITY_TRANSFER_FOG(o,o.vertex);
                        return o;
                    }
                    fixed4 frag(v2f i) : SV_Target
                    {
                        fixed4 col = tex2D(_FurTex, i.texcoord)* tex2D(_MainTex, i.texcoord);
                        col *= _Color*fixed4(1,1,1,1);
                        UNITY_APPLY_FOG(i.fogCoord, col);
                        // UNITY_OPAQUE_ALPHA(col.a);
                        return col;
                    }
                ENDCG
            }
            Pass {
                CGPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma target 2.0
                    #include "UnityCG.cginc"
                    struct appdata_t {
                        float4 vertex : POSITION;
                        float4 normal : NORMAL;
                        float2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                    };
                    struct v2f {
                        float4 vertex : SV_POSITION;
                        float4 normal : NORMAL;
                        float2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_OUTPUT_STEREO
                    };
                    sampler2D _MainTex;
                    sampler2D _FurTex;
                    float4 _FurTex_ST;
                    float4 _Color;
                    float _Ajust;
                    v2f vert(appdata_t v)
                    {
                        v2f o;
                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                        o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Ajust * 2);
                        o.texcoord = TRANSFORM_TEX(v.texcoord, _FurTex);
                        UNITY_TRANSFER_FOG(o,o.vertex);
                        return o;
                    }
                    fixed4 frag(v2f i) : SV_Target
                    {
                        fixed4 col = tex2D(_FurTex, i.texcoord)* tex2D(_MainTex, i.texcoord);
                        col *= _Color * fixed4(1, 1, 1, 0.9);
                        UNITY_APPLY_FOG(i.fogCoord, col);
                        // UNITY_OPAQUE_ALPHA(col.a);
                        return col;
                    }
                ENDCG
            }
            Pass{
               CGPROGRAM
                   #pragma vertex vert
                   #pragma fragment frag
                   #pragma target 2.0
                   #include "UnityCG.cginc"
                   struct appdata_t {
                       float4 vertex : POSITION;
                       float4 normal : NORMAL;
                       float2 texcoord : TEXCOORD0;
                       UNITY_VERTEX_INPUT_INSTANCE_ID
                   };
                   struct v2f {
                       float4 vertex : SV_POSITION;
                       float4 normal : NORMAL;
                       float2 texcoord : TEXCOORD0;
                       UNITY_VERTEX_OUTPUT_STEREO
                   };
                   sampler2D _MainTex;
                   sampler2D _FurTex;
                   float4 _FurTex_ST;
                   float4 _Color;
                   float _Ajust;
                   v2f vert(appdata_t v)
                   {
                       v2f o;
                       UNITY_SETUP_INSTANCE_ID(v);
                       UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                       o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Ajust * 3);
                       o.texcoord = TRANSFORM_TEX(v.texcoord, _FurTex);
                       UNITY_TRANSFER_FOG(o,o.vertex);
                       return o;
                   }
                   fixed4 frag(v2f i) : SV_Target
                   {
                       fixed4 col = tex2D(_FurTex, i.texcoord)* tex2D(_MainTex, i.texcoord);
                       col *= _Color * fixed4(1, 1, 1, 0.7);
                       UNITY_APPLY_FOG(i.fogCoord, col);
                       // UNITY_OPAQUE_ALPHA(col.a);
                       return col;
                   }
               ENDCG
                    }
            Pass{
              CGPROGRAM
                  #pragma vertex vert
                  #pragma fragment frag
                  #pragma target 2.0
                  #include "UnityCG.cginc"
                  struct appdata_t {
                      float4 vertex : POSITION;
                      float4 normal : NORMAL;
                      float2 texcoord : TEXCOORD0;
                      UNITY_VERTEX_INPUT_INSTANCE_ID
                  };
                  struct v2f {
                      float4 vertex : SV_POSITION;
                      float4 normal : NORMAL;
                      float2 texcoord : TEXCOORD0;
                      UNITY_VERTEX_OUTPUT_STEREO
                  };
                  sampler2D _MainTex;
                  sampler2D _FurTex;
                  float4 _FurTex_ST;
                  float4 _Color;
                  float _Ajust;
                  v2f vert(appdata_t v)
                  {
                      v2f o;
                      UNITY_SETUP_INSTANCE_ID(v);
                      UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                      o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Ajust * 4);
                      o.texcoord = TRANSFORM_TEX(v.texcoord, _FurTex);
                      UNITY_TRANSFER_FOG(o,o.vertex);
                      return o;
                  }
                  fixed4 frag(v2f i) : SV_Target
                  {
                      fixed4 col = tex2D(_FurTex, i.texcoord)* tex2D(_MainTex, i.texcoord);
                      col *= _Color * fixed4(1, 1, 1, 0.5);
                      UNITY_APPLY_FOG(i.fogCoord, col);
                      // UNITY_OPAQUE_ALPHA(col.a);
                      return col;
                  }
              ENDCG
                   }
            Pass{
              CGPROGRAM
                  #pragma vertex vert
                  #pragma fragment frag
                  #pragma target 2.0
                  #include "UnityCG.cginc"
                  struct appdata_t {
                      float4 vertex : POSITION;
                      float4 normal : NORMAL;
                      float2 texcoord : TEXCOORD0;
                      UNITY_VERTEX_INPUT_INSTANCE_ID
                  };
                  struct v2f {
                      float4 vertex : SV_POSITION;
                      float4 normal : NORMAL;
                      float2 texcoord : TEXCOORD0;
                      UNITY_VERTEX_OUTPUT_STEREO
                  };
                  sampler2D _MainTex;
                  sampler2D _FurTex;
                  float4 _FurTex_ST;
                  float4 _Color;
                  float _Ajust;
                  v2f vert(appdata_t v)
                  {
                      v2f o;
                      UNITY_SETUP_INSTANCE_ID(v);
                      UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                      o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Ajust * 5);
                      o.texcoord = TRANSFORM_TEX(v.texcoord, _FurTex);
                      UNITY_TRANSFER_FOG(o,o.vertex);
                      return o;
                  }
                  fixed4 frag(v2f i) : SV_Target
                  {
                      fixed4 col = tex2D(_FurTex, i.texcoord)* tex2D(_MainTex, i.texcoord);
                      col *= _Color * fixed4(1, 1, 1, 0.3);
                      UNITY_APPLY_FOG(i.fogCoord, col);
                      // UNITY_OPAQUE_ALPHA(col.a);
                      return col;
                  }
              ENDCG
                  }
            Pass{
                        CGPROGRAM
                            #pragma vertex vert
                            #pragma fragment frag
                            #pragma target 2.0
                            #include "UnityCG.cginc"
                            struct appdata_t {
                                float4 vertex : POSITION;
                                float4 normal : NORMAL;
                                float2 texcoord : TEXCOORD0;
                                UNITY_VERTEX_INPUT_INSTANCE_ID
                            };
                            struct v2f {
                                float4 vertex : SV_POSITION;
                                float4 normal : NORMAL;
                                float2 texcoord : TEXCOORD0;
                                UNITY_VERTEX_OUTPUT_STEREO
                            };
                            sampler2D _MainTex;
                            sampler2D _FurTex;
                            float4 _FurTex_ST;
                            float4 _Color;
                            float _Ajust;
                            v2f vert(appdata_t v)
                            {
                                v2f o;
                                UNITY_SETUP_INSTANCE_ID(v);
                                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                                o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Ajust * 6);
                                o.texcoord = TRANSFORM_TEX(v.texcoord, _FurTex);
                                UNITY_TRANSFER_FOG(o,o.vertex);
                                return o;
                            }
                            fixed4 frag(v2f i) : SV_Target
                            {
                                fixed4 col = tex2D(_FurTex, i.texcoord)* tex2D(_MainTex, i.texcoord);
                                col *= _Color * fixed4(1, 1, 1, 0.1);
                                UNITY_APPLY_FOG(i.fogCoord, col);
                                // UNITY_OPAQUE_ALPHA(col.a);
                                return col;
                            }
                        ENDCG
                  }
        }
}
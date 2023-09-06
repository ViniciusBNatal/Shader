Shader "Unlit/EX1"
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
			GLSLPROGRAM
			#include "UnityCG.glslinc"
			uniform vec4 _LightColor0;
			#ifdef VERTEX
				varying vec2 vUv;
				varying vec3 normal;
				varying vec4 color;
			void main() {
				// cor da luz da unity
				//_LightColor0

				// vetor da luz da unity
				//_WorldSpaceLightPos0

				// projeção da camera
				// gl_ProjectionMatrix
				
				// projeção do modelo
				// gl_ModelViewMatrix

				gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
				normal = gl_Normal;
				vUv = gl_MultiTexCoord0.xy;
				color = gl_Color;
			}

			#endif
			
			#ifdef FRAGMENT
				uniform sampler2D _MainTex;
				varying vec2 vUv;
				varying vec3 normal;
				varying vec4 color;
			void main() {		
				vec4 wnormal = gl_ModelViewMatrix * vec4(normal, 0);
				
				float finalColor = dot(wnormal, _WorldSpaceLightPos0);

				gl_FragColor = texture2D(_MainTex, vUv) * finalColor;
			}
			#endif
			ENDGLSL
		}
	}
}
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
				varying vec4 vPosition;
			void main() {
				// cor da luz da unity
				//_LightColor0

				// vetor da luz da unity
				//_WorldSpaceLightPos0

				// projeção da camera
				// gl_ProjectionMatrix
				
				// projeção do modelo
				// gl_ModelViewMatrix
				float mov = sin(4.0 * _Time.x + gl_Vertex.z * 3.0) * .5;
				vPosition = gl_Vertex + vec4(0, 0, mov, 1);
				gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * vPosition;
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
				varying vec4 vPosition;
			void main() {	
				vec4 wnormal = gl_ModelViewMatrix * vec4(normal, 0);
				
				float finalColor = dot(wnormal, _WorldSpaceLightPos0);

				if (vUv.y <= .3) {
					gl_FragColor = texture2D(_MainTex, vUv) * finalColor * vec4(1,0,0,1);
				}
				else if (vUv.y > .3 && <= .6) {
					gl_FragColor = texture2D(_MainTex, vUv) * finalColor * vec4(0, 1, 0, 1);
				}
				else {
					gl_FragColor = texture2D(_MainTex, vUv) * finalColor * vec4(0, 0, 1, 1);
				}

			}
			#endif
			ENDGLSL
		}
	}
}
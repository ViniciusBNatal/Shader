//shader de bandeira
Shader "Unlit/EX1"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color1("Color 1", Color) = (1,1,1,1)
		_Color2("Color 2", Color) = (1,1,1,1)
		_Color3("Color 3", Color) = (1,1,1,1)
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

				// proje��o da camera
				// gl_ProjectionMatrix

				// proje��o do modelo
				// gl_ModelViewMatrix
				float mov = sin(4.0 * _Time.w + gl_Vertex.z * 3.0) * .5;
				//vPosition = gl_Vertex + vec4(0, 0, mov, 1);
				gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
				normal = gl_Normal;
				vUv = gl_MultiTexCoord0.xy;
				color = gl_Color;
				//gl_Position.y += mov;
			}

			#endif

			#ifdef FRAGMENT
				uniform sampler2D _MainTex;
				uniform vec4 _Color1;
				uniform vec4 _Color2;
				uniform vec4 _Color3;
				varying vec2 vUv;
				varying vec3 normal;
				varying vec4 color;
				varying vec4 vPosition;
			void main() {

				vec3 wnormal = normalize(
					vec3(vec4(normal, 0.0) * unity_WorldToObject));

				vec3 lightpos = normalize(
					vec3(_WorldSpaceLightPos0));

				float finalcolor = dot(wnormal, lightpos);

				if (vUv.y <= .3) {
					gl_FragColor = texture2D(_MainTex, vUv) * finalcolor * _Color1;
				}
				else if (vUv.y > .3 && vUv.y <= .6) {
					gl_FragColor = texture2D(_MainTex, vUv) * finalcolor * _Color2;
				}
				else {
					gl_FragColor = texture2D(_MainTex, vUv) * finalcolor * _Color3;
				}

			}
			#endif
			ENDGLSL
		}
	}
	// coisas velhas
	/*
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

				// proje��o da camera
				// gl_ProjectionMatrix
				
				// proje��o do modelo
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
		*/
}
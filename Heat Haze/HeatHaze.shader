Shader "Hidden/HeatHaze"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise", 2D) = "white" {}
		_Max ("Max", float) = 1
		_Min ("Min", float) = 1
		_Falloff ("Falloff", float) = 0.5
		_Speed ("Speed", float) = 1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}

			//Get the camera depth texture.
			sampler2D _CameraDepthTexture;

			sampler2D _MainTex;
			sampler2D _NoiseTex;
			fixed _Max;
			fixed _Min;
			fixed _Falloff;
			fixed _Speed;
			fixed _Invert;

			fixed4 frag (v2f i) : SV_Target
			{
				//Calculate the depth value uses parameters and the depth buffer. This is used to scale the effect.
				fixed depth = clamp(pow(1 - tex2D(_CameraDepthTexture, fixed2(i.uv.x, 1 - i.uv.y)).r, _Falloff * 100), _Min, _Max);

				//Distort image using a noise texture.
				fixed4 noise = tex2D(_NoiseTex, fixed2(i.uv.x, i.uv.y + _Time.x * _Speed * 10));
				fixed distortion = depth * (0.5 - noise.r) * 0.05;
				fixed2 distortionUv = fixed2(i.uv.x + distortion, i.uv.y + distortion);

				//Apply the distorted uv to the camera view texture and return.
				fixed4 col = tex2D(_MainTex, distortionUv);
				return col;
			}
			ENDCG
		}
	}
}

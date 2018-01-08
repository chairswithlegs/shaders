Shader "Hidden/EyeImageEffect"
{
	Properties
	{
		_MainTex("Main Tex",2D) = "white"{}
		_EyelidTex ("Eyelid Texture", 2D) = "white" {}
		_EyelidAmount ("Eyelid Amount", Range(0,1)) = 0.5
		_BlurScale ("Blur Scale", Range(0,1)) = 0.5
		_BlurAmount ("Blur Amount", Range(0, 1)) = 0
		_BlurIter("Blur Iterations", Range(1,5)) = 5
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
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _EyelidTex;
			fixed _EyelidAmount;
			fixed _BlurScale;
			fixed _BlurAmount;
			fixed _BlurIter;

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

			fixed4 frag (v2f i) : SV_Target
			{
				//Set base color to black. A blend of the camera view image (or images) with a mask based on the eyelid texture will be added.
				float4 sum = float4 (0,0,0,0);

				//Add camera view in passes, each pass has a different vertical scale creating a double-vision effect.
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - max(_BlurIter - 4, 0) / _BlurIter * _BlurScale)) * 0.5;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - max(_BlurIter - 3, 0) / _BlurIter * _BlurScale)) * 0.25;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - max(_BlurIter - 2, 0) / _BlurIter * _BlurScale)) * 0.125;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - max(_BlurIter - 1, 0) / _BlurIter * _BlurScale)) * 0.085;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y - max(_BlurIter, 0) / _BlurIter * _BlurScale)) * 0.04;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + max(_BlurIter - 4, 0) / _BlurIter * _BlurScale)) * 0.5;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + max(_BlurIter - 3, 0) / _BlurIter * _BlurScale)) * 0.25;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + max(_BlurIter - 2, 0) / _BlurIter * _BlurScale)) * 0.125;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + max(_BlurIter - 1, 0) / _BlurIter * _BlurScale)) * 0.085;
				sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y + max(_BlurIter, 0) / _BlurIter * _BlurScale)) * 0.04;

				//Add the actual camera view image and blend.
				sum *= _BlurAmount / 2;
				sum += tex2D(_MainTex, i.uv) * (1-_BlurAmount);

				//Create the eyelid mask.
				float4 eyelid = tex2D(_EyelidTex, i.uv);
				float eye = min(eyelid.r + 1 - _EyelidAmount * 2, 1);

				//Blend the blurred camera view and eyelid mask.
				return lerp(fixed4(0,0,0,1), sum, eye);
			}
			ENDCG
		}
	}
}

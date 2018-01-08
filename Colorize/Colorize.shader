Shader "Hidden/Colorize"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Red ("Red", Float) = 1
		_Blue ("Blue", Float) = 1
		_Green ("Green", Float) = 1
		_Contrast ("Contrast", Float) = 0
		_Brightness ("Brightness", Float) = 0
		_Saturation ("Saturation", Float) = 0
	}
	SubShader
	{
		// No culling or depth.
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
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
			
			sampler2D _MainTex;
			fixed _Red;
			fixed _Blue;
			fixed _Green;
			fixed _Contrast;
			fixed _Brightness;
			fixed _Saturation;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				//Calculate luminosity of pixel.
				fixed lum = dot(fixed3(0.299, 0.587, 0.114), col.rgb);
				//Create grayscale value of pixel.
				fixed3 grayScale = fixed3 (lum, lum, lum);
				//Multiply initial pixel by selected color values.
				fixed3 blendColor = fixed3 (_Red * col.r, _Green * col.g, _Blue * col.b);
				//Blend, adjust brightness, and adjust contrast.
				fixed4 finalColor = fixed4 (lerp(grayScale, blendColor, _Saturation), col.a);
				finalColor += _Brightness;
				finalColor = pow(finalColor, _Contrast);
				return finalColor;
			}
			ENDCG
		}
	}
}

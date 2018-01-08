Shader "Hidden/TelevisionEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScanLineTex ("Scan Line Texture", 2D) = "black" {}
		_ScanTile("Scan Tile", Float) = 4.0
		_ScanLineSpeed ("Scan Speed", Float) = 1.0
		_Color("Night vision color", Color) = (1,1,1,1)
		_Contrast("Contrast", Range(0,4)) = 2
		_Brightness ("Brightness", Range(0,2)) = 1
		_RandomValue ("Random Value", Float) = 0
		_Distortion("Distortion", Float) = 0.2
		_Scale ("Scale", Float) = 0.8
		_NoiseTex ("Noise Texture", 2D) = "black" {}
		_ScanLineAmount ("Scan Line Amount", Float) = 1
		_NoiseAmount ("Noise Amount", Float) = 1
		_ColorAmount ("Color Amount", Float) = 0
		_Luminosity ("Luminosity", Float) = 1
		_VignetteTex ("Vignette Texture", 2D) = "white" {}
		_VignetteAmount ("Vignette Amount", Float) = 1
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
			sampler2D _ScanLineTex;
			sampler2D _NoiseTex;
			sampler2D _VignetteTex;
			fixed4 _Color;
			fixed _Contrast;
			fixed _Brightness;
			fixed _RandomValue;
			fixed _ScanTile;
			fixed _ScanLineSpeed;
			fixed _Distortion;
			fixed _Scale;
			fixed _ScanLineAmount;
			fixed _NoiseAmount;
			fixed _ColorAmount;
			fixed _Luminosity;
			fixed _VignetteAmount;

			float2 distortion (float2 coord)
			{
				//Simple barrel distortion
				float2 coords = coord.xy - float2(0.5, 0.5);
				float coordsSqr = coords.x * coords.x + coords.y * coords.y;
				float dis = 1.0 + coordsSqr * (_Distortion * sqrt(coordsSqr));

				return dis * _Scale * coords + 0.5;
			}

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
				//Distort the uv using barrel distoration
				half2 distortedUv = distortion(i.uv);
				fixed4 renderTex = tex2D(_MainTex, distortedUv);

				//Create the scanline and noise textures for a grainy video effect.
				half2 scanLinesUv = half2(i.uv.x * _ScanTile, i.uv.y * _ScanTile + _Time.x * _ScanLineSpeed);
				fixed4 scanLineTex = tex2D(_ScanLineTex, scanLinesUv);
				fixed4 noiseTex = tex2D(_NoiseTex, fixed2(i.uv.x + _RandomValue, i.uv.y + _RandomValue));

				//Calculate luminosity, tweaks colors, set brightness.
				fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb) * _Luminosity;
				fixed4 finalColor = lerp(renderTex, lum * _Color, _ColorAmount);
				finalColor += _Brightness;
				finalColor = pow(finalColor, _Contrast);

				//Apply grain and vignette effects.
				finalColor *= 1 - (scanLineTex * _ScanLineAmount);
				finalColor += noiseTex * _NoiseAmount;
				fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);
				finalColor += (vignetteTex - 1) * _VignetteAmount;

				return finalColor;
			}
			ENDCG
		}
	}
}

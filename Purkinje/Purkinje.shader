Shader "Hidden/Purkinje"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (0,0,0,0)
		_Strength ("Strength", float) = 0
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
			
			sampler2D _MainTex;
			fixed4 _Color;
			fixed _Strength;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				fixed lum = dot(fixed3(0.299, 0.587, 0.114), col.rgb);

				col.r = lerp(lum, col.r, pow(lum, 1 - _Color.r));
				col.g = lerp(lum, col.g, pow(lum, 1 - _Color.g));
				col.b = lerp(lum, col.b, pow(lum, 1 - _Color.b)); 

				return col;
			}
			ENDCG
		}
	}
}

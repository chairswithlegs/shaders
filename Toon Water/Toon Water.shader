Shader "Custom/ToonWater" {
	Properties {
		_WaterColor ("Water Color", Color) = (1,1,1,1)
		_LightFoamColor ("Light Foam Color", Color) = (1,1,1,1)
		_DarkFoamColor ("Dark Foam Color", Color) = (1,1,1,1)
		_Foam ("Foam Texture", 2D) = "white" {}
		_FoamStretch ("Foam Stretch", Range(0,1)) = 0.5
		_Frequency ("Wave Frequency", Range(0,1)) = 0.5
		_Amplitude ("Wave Amplitude", Range(0,1)) = 0.5
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		//Manually update the time to synchronize with game time (typically Time.time). See ToonWaterTimeSync.cs
		_Time0 ("Time", Float) = 0
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 400
		
		CGPROGRAM

		// Physically based Standard lighting model, and enable shadows on all light types.
		// Uses vert function to vertex manipulation (waves) and addshadow to update shadows to account for waves.
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow
		#pragma target 3.0

		struct Input {
			float2 uv_Foam;
			half stretch;
		};

		sampler2D _Foam;

		fixed4 _WaterColor;
		fixed4 _LightFoamColor;
		fixed4 _DarkFoamColor;
		fixed _FoamStretch;
		half _Frequency;
		half _Amplitude;
		half _Glossiness;
		half _Metallic;
		float _Time0;

		//Accepts world space and time, outputs the wave height.
		half waveHeight (half x, half z, half time) {
			half y = (sin((x * 1 + time) * _Frequency) + sin((x * 2 + time * 1.5) * _Frequency) + sin((x * 3 + time * 0.4) * _Frequency) / 3);
			y += (sin((z * 1 + time) * _Frequency) + sin((z * 2 + time * 1.5) * _Frequency) + sin((z * 3 + time * 0.4) * _Frequency) / 3);
			return y * _Amplitude / 2;
		}

		void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input, o);

			//Getting the world position of the vertex and pass into the wave function to get the height.
			half4 worldpos = mul(unity_ObjectToWorld, v.vertex);
			half y = waveHeight (worldpos.x, worldpos.z, _Time0);
			v.vertex.xyz = float3(v.vertex.x, v.vertex.y + y, v.vertex.z);

			//Update normals for more accurate lighting
			v.normal = normalize(float3(v.normal.x + y, v.normal.y, v.normal.z));

			//Pass a value into the surface shader for stretching the foam texture.
			o.stretch = y * _FoamStretch;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color.
			fixed4 c = _WaterColor;
			c += tex2D (_Foam, IN.uv_Foam + IN.stretch) * _LightFoamColor;
			c += tex2D (_Foam, IN.uv_Foam + IN.stretch / 2 + 0.5) * _DarkFoamColor;

			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

Shader "Custom/Hologram" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Emission ("Emission", Color) = (1,1,1,1)
		_NoiseTex ("Noise", 2D) = "white" {}
		_Speed ("Noise Speed", Range(-10, 10)) = 0
		_EdgeEffect ("Edge Effect", Range(0,1)) = 0.5
		_DistortionTex ("Distortaion Map", 2D) = "white" {}
		_Distortion ("Distoration Amount", Range(0,1)) = 0.5
		_DistortionSpeed ("Distoration Speed", Range(-1,1)) = 0
	}
	SubShader {
		Tags { 
			"RenderType"="Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		 }
		LOD 200

		//Turn off culling so that backfaces can be seen.
		Cull Off

		CGPROGRAM
		//Uses the Lambert and nolightmap for lighting settings, alpha:fade for transparency, and vert function for vertex manipulation.
		#pragma surface surf Lambert alpha:fade nolightmap vertex:vert
		#pragma target 3.0

		struct Input {
			//Uses the view direction and world normal for the rim effect (brighter on edges).
			float3 viewDir;
			float3 worldNormal;
		};

		fixed4 _Color;
		fixed4 _Emission;
		sampler2D _NoiseTex;
		fixed _Distortion;
		sampler2D _DistortionTex;
		fixed _DistortionSpeed;
		fixed _Speed;
		fixed _EdgeEffect;

		void vert (inout appdata_full v) {
		    //Distorts the vertex based on the distoration texture.
			float4 tex = tex2Dlod (_DistortionTex, float4(v.texcoord.x, v.texcoord.y + _DistortionSpeed * _Time.x, 0, 0));
			v.vertex.xyz += v.normal * _Distortion * (tex.r - 0.5);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			//scales the y axis of the UV overtime to give the scanlines movement.
			fixed2 uv = fixed2(IN.viewDir.x, IN.viewDir.y + _Speed * _Time.x);

			//Generate and apply the scanlines texture using the calculated UV from above.
			fixed4 c = tex2D (_NoiseTex, uv) * _Color;
			o.Albedo = c.rgb;

			o.Emission = _Emission;

			//Apply the rim effect and transparency.
			float edge = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float alpha = edge * (1 - _EdgeEffect) + _EdgeEffect;
			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
}

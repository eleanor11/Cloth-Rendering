Shader "Custom/DiffuseShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "red" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		inline float4 LightingCustomDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten) {
			float difLight = max(0, dot (s. Normal, lightDir));
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * difLight * atten * 2;
			col.a = s.Alpha;
			return col;
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}

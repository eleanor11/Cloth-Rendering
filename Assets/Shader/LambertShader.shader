Shader "Custom/LambertShader" {
	Properties {
		_Color ("Color", Color) = (1, 1, 0, 1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lamb

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _Bump;  
		fixed4 _Color;
		

		struct Input {
			float2 uv_MainTex;
            float2 uv_Bump;
		};
		

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		
		inline fixed4 LightingLamb(SurfaceOutput s, fixed3 lightDir, fixed atten) {
		
			float diff = dot(s.Normal, lightDir);
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff);
			c.a = 1.0;
			return c;
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}

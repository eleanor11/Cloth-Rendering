Shader "Custom/BlinPhongShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
		_MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
		_SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
		_SpecularPower ("Spercular Power", Range(0, 30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Phong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _Bump;  
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecularPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
		};


		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;

            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		inline fixed4 LightingPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			float diff = dot(s.Normal, lightDir);
			float3 halfVector = normalize(lightDir + viewDir);
			float spec = pow(max(0, dot(halfVector, s.Normal)), _SpecularPower);
			float3 finalSpec = _SpecularColor * spec;
			
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = 1.0;
			return c;
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}

Shader "Custom/CookTorranceShader" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
        _RoughnessTex ("Roughness texture", 2D) = "" {}
        _Roughness ("Roughness", Range(0, 1)) = 0.5
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower ("Specular Power", Range(0, 30)) = 2
        _Fresnel ("Fresnel Value", Range(0, 1.0)) = 0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf MetallicSoft

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _Bump;  
        sampler2D _RoughnessTex;
        float _Roughness;
        float _Fresnel;
        float _SpecPower;
        float4 _MainTint;
        float4 _SpecularColor;

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
		
		inline fixed4 LightingMetallicSoft (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
		
			//Compute simple diffuse and view direction values
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotL = saturate(dot(s.Normal, normalize(lightDir)));
			float NdotH_raw = dot(s.Normal, halfVector);
			float NdotH = saturate(dot(s.Normal, halfVector));
			float NdotV = saturate(dot(s.Normal, normalize(viewDir)));
			float VdotH = saturate(dot(halfVector, normalize(viewDir)));
			
			//Micro facet distribution
			float geoEnum = 2.0 * NdotH;
			float3 G1 = (geoEnum * NdotV) / NdotH;
			float3 G2 = (geoEnum * NdotL) / NdotH;
			float3 G = min(1.0f, min(G1, G2));
			
			//Sample out Specular look up BRDF
			float roughness = tex2D(_RoughnessTex, float2(NdotH_raw * 0.5 + 0.5, _Roughness)).r;
			
			//Create our custom fresnel value
			float fresnel = pow(1.0 - VdotH, 5.0);
			fresnel *= (1.0 - _Fresnel);
			fresnel += _Fresnel;
			
			//Create the final spec
			float3 spec = float3(fresnel * G * roughness * roughness) * _SpecPower;
			
			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (spec * _SpecularColor.rgb) * (atten * 2.0f);
			c.a = s.Alpha;
			return c;
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}

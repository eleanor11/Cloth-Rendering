Shader "Custom/MyShader0" {
	Properties {		
		_MainTint ("Global Tint", Color) = (1.0, 0.55, 0.55, 1)
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_DetailBump ("Detail Normal Map", 2D) = "bump" {}
		_DetailTex ("Fabric Weave", 2D) = "white" {}
		_BitMap ("Bit Map", 2D) = "white" {}
		_FresnelPower ("Fresnel Power", Range(0, 12)) = 3
		_RimPower ("Rim FallOff", Range(0, 12)) = 3
		_SpecIntesity ("Specular Intensity", Range(0, 1)) = 0.2
		_SpecWidth ("Specular Width", Range(0, 1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Velvet 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _BumpMap;
		sampler2D _DetailBump;
		sampler2D _DetailTex;
		sampler2D _BitMap;
		float4 _MainTint;
		float4 _FresnelColor;
		float _FresnelPower;
		float _RimPower;
		float _SpecIntesity;
		float _SpecWidth;

		struct Input {
			float2 uv_BumpMap;
			float2 uv_DetailBump;
			float2 uv_DetailTex;
			float2 uv_BitMap;
		};
		
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture
			half4 c = tex2D (_DetailTex, IN.uv_DetailTex);
			half t = tex2D (_BitMap, IN.uv_BitMap).x;
			
			fixed3 normals = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)).rgb;
			fixed3 detailNormals = UnpackNormal(tex2D(_DetailBump, IN.uv_DetailBump)).rgb;
			fixed3 finalNormals = float3(normals.x + detailNormals.x, normals.y + detailNormals.y, normals.z + detailNormals.z);
			
			o.Normal = normalize(finalNormals);
			
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = t;
		}
		inline fixed4 LightingVelvet (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
		
			fixed4 c;
			
			if (s.Alpha == 1){
				float diff = dot(s.Normal, lightDir);
				c.rgb = (s.Albedo * _LightColor0.rgb * diff);
				c.a = 1.0;
			}
			else {
				//Create lighting vectors here  
				viewDir = normalize(viewDir);
				lightDir = normalize(lightDir);
				half3 halfVec = normalize(lightDir + viewDir);
				fixed NdotL = max(0, dot(s.Normal, lightDir));
			
				//Create Specular
				float NdotH = max(0, dot(s.Normal, halfVec));
				float spec = pow(NdotH, s.Specular * 128.0) * s.Gloss;
			
				//Create Fresnel
				float HdotV = pow(1 - max(0, dot(halfVec, viewDir)), _FresnelPower);
				float NdotE = pow(1 - max(0, dot(s.Normal, viewDir)), _RimPower);
				float finalSpecMask = NdotE * HdotV;
		
				//Output the final color
				c.rgb = (s.Albedo * NdotL * _LightColor0.rgb) + (spec * (finalSpecMask * _FresnelColor)) * (atten * 2);
				c.a = 1.0;
			}
			
			return c;
					
		}

		ENDCG
	} 
	FallBack "Diffuse"
}

Shader "Custom/MyShader2" {
	Properties {		
		_MainTint ("Global Tint", Color) = (1.0, 0.55, 0.55, 1)
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_DetailBump ("Detail Normal Map", 2D) = "bump" {}
		_DetailTex ("Fabric Weave", 2D) = "white" {}
		_BitMap ("Bit Map", 2D) = "white" {}
		_SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
		_SpecularPower ("Spercular Power", Range(0, 1)) = 0.75
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
		float4 _SpecularColor;
		float _SpecularPower;

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
				float diff = dot(s.Normal, lightDir);
				float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
				float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecularPower * 100);
				float3 finalSpec = _SpecularColor * spec;
				
				c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
				c.a = 1.0;
			}
			
			return c;
					
		}

		ENDCG
	} 
	FallBack "Diffuse"
}

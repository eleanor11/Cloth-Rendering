Shader "Custom/VertexShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
		_Amount("Extrusion Amount", Range(-5, 5)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _Bump;  
		float _Amount;
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
		
		void vert (inout appdata_full v) {
			fixed3 normal = UnpackNormal(tex2Dlod(_Bump, v.texcoord));
			//v.normal.xyz = (float3) normal;
			v.vertex.xyz += normal * _Amount;// * (sin(v.vertex.x) * sin(v.vertex.z * 100));
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}

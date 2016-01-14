Shader "Eleanor/NewShader" {
	Properties {
		_MainTint ("Global Tint", Color) = (0.55, 0.55, 1.0, 1)
		_SubTint ("Global Tint", Color) = (0.55, 0.55, 1.0, 1)
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BitMap ("Bit Map", 2D) = "grey" {}
		_Check ("Check", Range(0, 1)) = 0
		_FresnelPower ("Fresnel Power", Range(0, 10)) = 3
		_FresnelPowerRow ("Fresnel Power Row", Range(0, 10)) = 2
		_FresnelPowerCol ("Fresnel Power Col", Range(0, 10)) = 8
		_kd	("Isotropic Scattering Coefficient", Range(0, 1)) = 0.5
		_A ("Colored Aldebo Coefficient", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Cloth

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _MainTint;
		float4 _SubTint;
		sampler2D _BumpMap;
		sampler2D _BitMap;
		float _Check;
		float _FresnelPower;
		float _FresnelPowerRow;
		float _FresnelPowerCol;
		float _kd;
		float _A;
		
		struct Input {
			float2 uv_BumpMap;
			float2 uv_BitMap;
		};
		
		void surf (Input IN, inout SurfaceOutput o) {
		
			half t = tex2D (_BitMap, IN.uv_BitMap).x;
			
			fixed3 normals = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)).rgb;
			o.Normal = normalize(normals);
			
			if (t == 0){
				o.Albedo = _MainTint;
			}
			else {
				o.Albedo = _SubTint;
			}
            
			o.Alpha = t;
		}
		
		inline fixed4 LightingCloth(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			
			fixed4 c;
			
			float PI = 3.14159265358979323846264338327;
			float halfPI = PI / 2;
			
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			fixed3 normal = s.Normal;
			fixed3 t = normalize(fixed3(0.5, 0.5, 0.5));
			
			if (s.Alpha == _Check) {
				t = normalize(fixed3(1, 0.5, 0.5));
				_FresnelPower = _FresnelPowerRow;
			}else if (s. Alpha == 1 - _Check) {
				t = normalize(fixed3(0.5, 1, 0.5));
				_FresnelPower = _FresnelPowerCol;
			}
			
			fixed LdotT = dot(lightDir, t);
			fixed RdotT = dot(viewDir, t);
			fixed LdotN = dot(lightDir, normal);
			fixed RdotN = dot(lightDir, normal);
			
			fixed thetaI = abs(halfPI - acos(LdotT));
			fixed thetaR = abs(halfPI - acos(RdotT));
			
			fixed3 n1 = normalize(lightDir * t);
			fixed phiI = abs(halfPI - acos(dot(n1, normal)));
			fixed3 n2 = normalize(viewDir * t);
			fixed phiR = abs(halfPI - acos(dot(n2, normal)));
				
			fixed phiD = phiI - phiR;
			fixed thetaH = (thetaI + thetaR) / 2;
			fixed thetaD = (thetaI - thetaR) / 2;
			
			//Surface Reflection
			float FresnelR = pow(1 - max(0, acos(cos(thetaD) * cos(phiD / 2))), _FresnelPower);
			float gS = 1;
			fixed fS = FresnelR * cos(phiD / 2) * gS;
				
			//Volume Scattering
			float FresnelT = pow(1 - max(0, dot(lightDir, normal)), _FresnelPower);
			FresnelT *= pow(1 - max(0, dot(viewDir, normal)), _FresnelPower);
			float gV = 1;
			fixed fV = FresnelT * ((1 - _kd) * gV + _kd) * _A / (cos(thetaI) + cos(thetaR));
			
			//final 
			fixed f = (fS + fV) / pow(cos(thetaD), 2);
			
			//Output the final color
			if (f == 0) {
				f = 1;
			}
			c.rgb = s.Albedo * f;
			c.a = 1.0;
			
			
			return c;
		
		}
		
		ENDCG
	} 
	FallBack "Diffuse"
}

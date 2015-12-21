Shader "Custom/NormalShader" {  
    Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Bump ("Bump", 2D) = "bump" {}
		_MainTint ("Diffuse Tint", Color) = (0.75, 0.25, 0.75, 1)
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
		#include "UnityCG.cginc"

        sampler2D _MainTex;
        sampler2D _Bump;  
        fixed4 _Color;    
		fixed4 _MainTint;          

        struct Input {
            float2 uv_MainTex;
            float2 uv_Bump;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;

            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    } 
    FallBack "Diffuse"
}

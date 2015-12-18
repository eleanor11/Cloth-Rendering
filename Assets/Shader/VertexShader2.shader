Shader "Custom/VertexShader2" {
	Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		
		Pass {
			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma vertex vert
			#pragma fragment frag
	
			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0
		
			struct appdata {
				float4 vertex: POSITION;
				float2 uv: TEXCOORD0;
			};
		
			struct v2f {
				float2 uv: TEXCOORD0;
				float4 vertex: SV_POSITION;
			};
		
			v2f vert(appdata v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
				
			}
	
			sampler2D _MainTex;
			fixed4 _Color;
	
			fixed4 frag(v2f i): SV_Target {
				fixed4 c = tex2D(_MainTex, i.uv) * _Color;
				return c;
			}
	
			ENDCG
		} 
	}	
}
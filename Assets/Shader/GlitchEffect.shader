Shader "Custom/GlitchEffect" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _GlitchIntensity ("Glitch Intensity", Float) = 0.1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST; // Para manejar tiling y offset
            float _GlitchIntensity;

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; // Transformación de UV manual
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // Introducir distorsión aleatoria en las coordenadas de textura
                float glitch = sin(_Time.y * 10.0) * _GlitchIntensity;
                float2 distortedUV = i.uv + float2(glitch, 0);
                return tex2D(_MainTex, distortedUV);
            }
            ENDCG
        }
    }
}

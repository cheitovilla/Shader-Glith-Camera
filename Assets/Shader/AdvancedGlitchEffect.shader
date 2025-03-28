Shader "Custom/AdvancedGlitchEffect" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _GlitchIntensity ("Glitch Intensity", Float) = 0.1
        _NoiseIntensity ("Noise Intensity", Float) = 0.1
        _ScanlineFrequency ("Scanline Frequency", Float) = 500.0
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
            float4 _MainTex_ST; // Transformación UV (Tiling y Offset)
            float _GlitchIntensity;
            float _NoiseIntensity;
            float _ScanlineFrequency;

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
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; // Transformación UV manual
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // **Ruido Aleatorio**
                float randomNoise = frac(sin(dot(i.uv * _Time.y, float2(12.9898, 78.233))) * 43758.5453) * _NoiseIntensity;

                // **Desfase de Colores (RGB Split)**
                float2 glitchOffset = float2(sin(_Time.y * 10.0) * _GlitchIntensity, 0);
                float3 color;
                color.r = tex2D(_MainTex, i.uv + glitchOffset).r; // Desfase en rojo
                color.g = tex2D(_MainTex, i.uv - glitchOffset).g; // Desfase en verde
                color.b = tex2D(_MainTex, i.uv).b;                // Azul sin desplazamiento

                // **Scanlines**
                float scanline = sin(i.uv.y * _ScanlineFrequency) * 0.5 + 0.5; // Oscila entre 0 y 1
                scanline = step(0.5, scanline); // Convierte a blanco o negro para líneas más nítidas

                // **Combinar Efectos**
                float3 finalColor = color + randomNoise; // Añadir ruido visual
                finalColor *= scanline; // Aplicar scanlines

                return fixed4(finalColor, 1.0); // Devuelve el color combinado
            }
            ENDCG
        }
    }
}

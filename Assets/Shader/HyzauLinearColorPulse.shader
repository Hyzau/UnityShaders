Shader "Hyzau/LinearColorPulse"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Pulse Color", Color) = (1,1,1,1)
        _Frequency("Pulse Frequency", Float) = 2
        _Delay("Pulse Delay", Range(0.0, 0.99)) = 0.8
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest[unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha // Here use SrcAlpha One for additive material

        Pass
        {
            Name "LinearColorPulse"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            struct MeshData
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            fixed4 _Color;
            fixed4 _TextureSampleAdd;

            v2f vert(MeshData IN)
            {
                v2f OUT;
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color;
                return OUT;
            }

            sampler2D _MainTex;
            float _Frequency;
            float _Delay;

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color; // The default texture color
                float a = color.a;
                float distance = IN.texcoord.y;
                float wave = abs(cos((distance - _Time.y) * _Frequency )) - _Delay;
                float multiplier = 1 / (1 - _Delay); // Delay should not be equal to 1
                wave = saturate(wave * multiplier);
                //wave *= 1 - radialDistance; // This make the wave "smaller" the further away 
                _Color *= wave;
                color *= 1 - wave;
                color += _Color;
                color.a = a;
                return color;
            }
        ENDCG
        }
    }
}
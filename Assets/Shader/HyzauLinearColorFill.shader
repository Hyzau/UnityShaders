Shader "Hyzau/LinearColorFill"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Fill Color", Color) = (1,1,1,1)
        _Fill("Fill Percentage", Range(0, 1)) = 0.5
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
            Name "LinearColorFill"
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
            float _Fill;

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 texColor = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color; // The default texture color
                float a = texColor.a;
                float distance = IN.texcoord.y;
                float diff = _Fill - distance;
                float texMult = step(diff, 0);
                float colorMult = 1 - texMult;
                texColor *= texMult;
                texColor += (_Color * colorMult);
                texColor.a = a;
                return texColor;
            }
            ENDCG
        }
    }
}